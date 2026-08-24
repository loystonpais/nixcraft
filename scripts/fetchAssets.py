#!/usr/bin/env python3
"""
Minecraft Asset Fetcher
Downloads assets defined in a Minecraft asset index JSON file with support for:
- HTTP Keep-Alive persistent connection pooling per worker thread for ultra-fast downloads.
- Multiple read cache directories for fast lookups.
- A write cache directory for persisting newly downloaded assets across builds.
- In-flight SHA-1 checksum verification.
- Real-time continuous progress reporting for both TTY and Nix build logs.
"""

import argparse
import concurrent.futures
import hashlib
import http.client
import json
import os
import shutil
import ssl
import sys
import threading
import time
import urllib.parse
from pathlib import Path
from typing import Dict, List, Optional, Tuple

_thread_local = threading.local()


def get_http_connection(
    scheme: str,
    host: str,
    port: int,
    timeout: float,
) -> http.client.HTTPConnection:
    """Retrieves or establishes a thread-local persistent HTTP/HTTPS connection."""
    conn = getattr(_thread_local, "conn", None)
    if conn is None:
        if scheme == "https":
            ssl_ctx = ssl.create_default_context()
            conn = http.client.HTTPSConnection(
                host,
                port=port,
                timeout=timeout,
                context=ssl_ctx,
            )
        else:
            conn = http.client.HTTPConnection(
                host,
                port=port,
                timeout=timeout,
            )
        _thread_local.conn = conn
    return conn


def reset_http_connection() -> None:
    """Closes and resets the thread-local connection on network error or timeout."""
    conn = getattr(_thread_local, "conn", None)
    if conn is not None:
        try:
            conn.close()
        except Exception:
            pass
        _thread_local.conn = None


def calculate_sha1(filepath: Path) -> str:
    """Computes the SHA-1 hexadecimal digest of a local file."""
    hasher = hashlib.sha1()
    with open(filepath, "rb") as f:
        while chunk := f.read(65536):
            hasher.update(chunk)
    return hasher.hexdigest()


def find_in_read_caches(
    sha1: str,
    size: Optional[int],
    read_cache_dirs: List[Path],
) -> Optional[Path]:
    """
    Searches for an asset across all configured read cache directories.
    Checks directory layouts:
    - <cache_dir>/<prefix>/<sha1>
    - <cache_dir>/<sha1>
    - <cache_dir>/asset-objects/<prefix>/<sha1>
    - <cache_dir>/objects/<prefix>/<sha1>
    """
    prefix = sha1[:2]
    candidate_rel_paths = [
        Path(prefix) / sha1,
        Path(sha1),
        Path("asset-objects") / prefix / sha1,
        Path("objects") / prefix / sha1,
    ]

    for base_dir in read_cache_dirs:
        for rel_path in candidate_rel_paths:
            candidate = base_dir / rel_path
            if candidate.is_file():
                if size is not None and candidate.stat().st_size != size:
                    continue
                return candidate
    return None


def link_or_copy(src: Path, dest: Path) -> None:
    """Tries to create a hard link; falls back to copying if on different filesystems."""
    dest.parent.mkdir(parents=True, exist_ok=True)
    if dest.exists():
        dest.unlink()
    try:
        os.link(src, dest)
    except OSError:
        shutil.copyfile(src, dest)


_write_warning_shown = False


def save_to_write_cache(
    src_file: Path,
    sha1: str,
    write_cache_dir: Optional[Path],
) -> None:
    """Atomically copies a newly fetched asset to the write cache directory if available."""
    global _write_warning_shown
    if not write_cache_dir:
        return

    cache_target = write_cache_dir / sha1[:2] / sha1
    try:
        cache_target.parent.mkdir(parents=True, exist_ok=True)
        try:
            os.chmod(cache_target.parent, 0o777)
        except Exception:
            pass

        temp_target = cache_target.with_name(
            f"{sha1}.tmp.{os.getpid()}.{threading.get_ident()}"
        )
        shutil.copyfile(src_file, temp_target)
        try:
            os.chmod(temp_target, 0o666)
        except Exception:
            pass

        temp_target.replace(cache_target)
    except Exception as e:
        if not _write_warning_shown:
            _write_warning_shown = True
            print(
                f"\nWarning: Failed to write asset to cache '{cache_target}': {e}",
                file=sys.stderr,
            )


def download_asset(
    parsed_base: urllib.parse.ParseResult,
    prefix_sha1_path: str,
    dest_path: Path,
    expected_sha1: str,
    expected_size: Optional[int],
    retries: int,
    timeout: float,
) -> None:
    """Downloads a single asset using persistent HTTP connection with exponential backoff and SHA-1 verification."""
    if dest_path.is_file():
        return

    dest_path.parent.mkdir(parents=True, exist_ok=True)
    temp_path = dest_path.with_name(
        f"{dest_path.name}.tmp.{os.getpid()}.{threading.get_ident()}"
    )

    scheme = parsed_base.scheme or "https"
    host = parsed_base.netloc
    port = parsed_base.port or (443 if scheme == "https" else 80)
    base_path = parsed_base.path.rstrip("/")
    req_path = f"{base_path}/{prefix_sha1_path}" if base_path else f"/{prefix_sha1_path}"

    last_error: Optional[Exception] = None
    for attempt in range(1, retries + 1):
        try:
            if dest_path.is_file():
                return

            conn = get_http_connection(scheme, host, port, timeout)
            conn.request(
                "GET",
                req_path,
                headers={
                    "User-Agent": "nixcraft-asset-fetcher/1.0",
                    "Accept-Encoding": "identity",
                    "Connection": "keep-alive",
                },
            )
            response = conn.getresponse()

            if response.status != 200:
                response.read()  # drain response buffer before resetting
                reset_http_connection()
                raise http.client.HTTPException(
                    f"HTTP {response.status}: {response.reason}"
                )

            hasher = hashlib.sha1()
            bytes_written = 0
            with open(temp_path, "wb") as out_file:
                while chunk := response.read(65536):
                    hasher.update(chunk)
                    out_file.write(chunk)
                    bytes_written += len(chunk)

            actual_sha1 = hasher.hexdigest().lower()
            if actual_sha1 != expected_sha1.lower():
                temp_path.unlink(missing_ok=True)
                reset_http_connection()
                raise ValueError(
                    f"Checksum mismatch for {req_path}: expected {expected_sha1}, got {actual_sha1}"
                )

            if expected_size is not None and bytes_written != expected_size:
                temp_path.unlink(missing_ok=True)
                reset_http_connection()
                raise ValueError(
                    f"Size mismatch for {req_path}: expected {expected_size}, got {bytes_written}"
                )

            try:
                temp_path.replace(dest_path)
            except OSError:
                if not dest_path.is_file():
                    raise
            return

        except Exception as err:
            last_error = err
            temp_path.unlink(missing_ok=True)
            reset_http_connection()
            if attempt < retries:
                sleep_time = 0.2 * (2 ** (attempt - 1))
                time.sleep(sleep_time)

    raise RuntimeError(
        f"Failed to download {req_path} after {retries} attempts: {last_error}"
    )


def process_asset(
    name: str,
    meta: Dict,
    asset_type: str,
    out_dir: Path,
    read_cache_dirs: List[Path],
    write_cache_dir: Optional[Path],
    parsed_base: urllib.parse.ParseResult,
    retries: int,
    timeout: float,
) -> str:
    """Processes a single asset: checks read caches, downloads on miss, and writes to target/cache."""
    sha1 = meta["hash"]
    size = meta.get("size")
    prefix = sha1[:2]
    prefix_sha1_path = f"{prefix}/{sha1}"

    if asset_type == "legacy":
        dest_path = out_dir / "virtual" / "legacy" / name
    else:
        dest_path = out_dir / "objects" / prefix / sha1

    # 1. Check in read cache directories
    cached_file = find_in_read_caches(sha1, size, read_cache_dirs)
    if cached_file:
        link_or_copy(cached_file, dest_path)
        return "cached"

    # 2. Download from CDN with connection reuse
    download_asset(
        parsed_base=parsed_base,
        prefix_sha1_path=prefix_sha1_path,
        dest_path=dest_path,
        expected_sha1=sha1,
        expected_size=size,
        retries=retries,
        timeout=timeout,
    )

    # 3. Write to write cache if configured
    save_to_write_cache(dest_path, sha1, write_cache_dir)
    return "downloaded"


def render_progress(
    completed: int,
    total: int,
    cached: int,
    downloaded: int,
    errors: int,
    is_tty: bool,
    last_render_time: float,
    force: bool = False,
) -> float:
    """Renders a progress bar with cached vs downloaded asset counts."""
    now = time.time()
    # In TTY: update every 80ms. In non-TTY (Nix daemon build logs): update every 1.0s or on completion
    interval = 0.08 if is_tty else 1.0
    if not force and (now - last_render_time < interval):
        return last_render_time

    pct = (completed / total * 100) if total > 0 else 100.0
    bar_width = 25
    filled = int(bar_width * (completed / total)) if total > 0 else bar_width
    bar = "=" * filled + "-" * (bar_width - filled)

    status = (
        f"[{bar}] {pct:5.1f}% ({completed}/{total}) "
        f"| Cached: {cached} | Downloaded: {downloaded}"
    )
    if errors > 0:
        status += f" | Failed: {errors}"

    if is_tty:
        sys.stdout.write(f"\r{status}")
    else:
        sys.stdout.write(f"{status}\n")
    sys.stdout.flush()

    return now


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Fast, reliable, cache-aware Minecraft asset fetcher."
    )
    parser.add_argument(
        "--index",
        type=Path,
        required=True,
        help="Path to the assetIndex.json file",
    )
    parser.add_argument(
        "--asset-type",
        type=str,
        default="objects",
        help="Asset type (e.g. 'legacy', '1.21', or name for index placement)",
    )
    parser.add_argument(
        "--out-dir",
        type=Path,
        required=True,
        help="Target output directory ($out)",
    )
    parser.add_argument(
        "--read-cache-dirs",
        type=Path,
        nargs="*",
        default=[],
        help="One or more directories to read/lookup cached assets from",
    )
    parser.add_argument(
        "--write-cache-dir",
        type=Path,
        default=None,
        help="Directory to write newly downloaded assets into",
    )
    parser.add_argument(
        "--threads",
        type=int,
        default=24,
        help="Maximum concurrent download worker threads (default: 24)",
    )
    parser.add_argument(
        "--retries",
        type=int,
        default=5,
        help="Number of retries per asset on failure (default: 5)",
    )
    parser.add_argument(
        "--timeout",
        type=float,
        default=15.0,
        help="HTTP socket timeout in seconds (default: 15.0)",
    )
    parser.add_argument(
        "--base-url",
        type=str,
        default="https://resources.download.minecraft.net",
        help="Base URL for Minecraft assets",
    )

    args = parser.parse_args()

    if not args.index.is_file():
        print(f"Error: Asset index file '{args.index}' does not exist.", file=sys.stderr)
        sys.exit(1)

    with open(args.index, "r") as f:
        index_data = json.load(f)

    objects = index_data.get("objects", {})
    total_assets = len(objects)

    args.out_dir.mkdir(parents=True, exist_ok=True)

    # Place index in $out/indexes/<asset_type>.json
    indexes_dir = args.out_dir / "indexes"
    indexes_dir.mkdir(parents=True, exist_ok=True)
    target_index_file = indexes_dir / f"{args.asset_type}.json"
    shutil.copyfile(args.index, target_index_file)

    # Filter valid read cache directories that actually exist
    valid_read_cache_dirs = [p for p in args.read_cache_dirs if p.is_dir()]
    if valid_read_cache_dirs:
        print(
            f"Using {len(valid_read_cache_dirs)} read cache directories: "
            f"{', '.join(str(d) for d in valid_read_cache_dirs)}"
        )

    valid_write_cache_dir = None
    if args.write_cache_dir:
        try:
            args.write_cache_dir.mkdir(parents=True, exist_ok=True)
            test_file = args.write_cache_dir / f".write_test_{os.getpid()}"
            test_file.touch()
            test_file.unlink()
            valid_write_cache_dir = args.write_cache_dir
            print(f"Using write cache directory: {args.write_cache_dir}")
        except Exception as e:
            print(
                f"Warning: Write cache directory '{args.write_cache_dir}' is not writable: {e}\n"
                f"         (Ensure host cache directory exists with 0777 permissions and is in extra-sandbox-paths)",
                file=sys.stderr,
            )

    print(
        f"Processing {total_assets} assets for '{args.asset_type}' using up to {args.threads} threads..."
    )

    parsed_base = urllib.parse.urlparse(args.base_url)

    cached_count = 0
    downloaded_count = 0
    errors: List[Tuple[str, str]] = []

    start_time = time.time()
    is_tty = sys.stdout.isatty()
    last_render_time = 0.0

    # Initial 0% progress line
    last_render_time = render_progress(
        completed=0,
        total=total_assets,
        cached=0,
        downloaded=0,
        errors=0,
        is_tty=is_tty,
        last_render_time=last_render_time,
        force=True,
    )

    with concurrent.futures.ThreadPoolExecutor(max_workers=args.threads) as executor:
        future_to_asset = {
            executor.submit(
                process_asset,
                name=name,
                meta=meta,
                asset_type=args.asset_type,
                out_dir=args.out_dir,
                read_cache_dirs=valid_read_cache_dirs,
                write_cache_dir=valid_write_cache_dir,
                parsed_base=parsed_base,
                retries=args.retries,
                timeout=args.timeout,
            ): name
            for name, meta in objects.items()
        }

        for future in concurrent.futures.as_completed(future_to_asset):
            name = future_to_asset[future]
            try:
                result = future.result()
                if result == "cached":
                    cached_count += 1
                else:
                    downloaded_count += 1
            except Exception as e:
                errors.append((name, str(e)))

            completed = cached_count + downloaded_count + len(errors)
            last_render_time = render_progress(
                completed=completed,
                total=total_assets,
                cached=cached_count,
                downloaded=downloaded_count,
                errors=len(errors),
                is_tty=is_tty,
                last_render_time=last_render_time,
                force=(completed == total_assets),
            )

    if is_tty:
        sys.stdout.write("\n")
        sys.stdout.flush()

    duration = time.time() - start_time

    print(f"\nAsset fetching summary:")
    print(f"  Total:      {total_assets}")
    print(f"  Cached:     {cached_count}")
    print(f"  Downloaded: {downloaded_count}")
    print(f"  Duration:   {duration:.2f}s")

    if errors:
        print(f"\nFailed to fetch {len(errors)} assets:", file=sys.stderr)
        for name, err in errors[:10]:
            print(f"  - {name}: {err}", file=sys.stderr)
        if len(errors) > 10:
            print(f"  ... and {len(errors) - 10} more", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
