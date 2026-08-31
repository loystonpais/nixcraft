#!/usr/bin/env python3
"""
Nixcraft Minecraft Authentication Helper

Provides Microsoft Live OAuth Device Code authentication,
Xbox Live / Mojang token exchanges, atomic file caching, and
concurrency-safe token retrieval for Minecraft clients.

Directory layout:
<auth-dir>/<uuid>/
  ├── last-known-username
  ├── refresh-token
  ├── mc-token
  └── mc-token-expires
"""

import argparse
import json
import os
import ssl
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from contextlib import contextmanager
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

CLIENT_ID = "000000004c12ae6f"
SCOPE = "service::user.auth.xboxlive.com::MBI_SSL"
EXPIRY_BUFFER_SECONDS = 300
_SSL_CONTEXT = ssl.create_default_context()


def normalize_uuid(uuid_str: str) -> str:
    """Strip hyphens and lowercase UUID string."""
    return uuid_str.replace("-", "").strip().lower()


def _http_request(
    url: str,
    method: str = "GET",
    data: Optional[Dict[str, Any]] = None,
    json_data: Optional[Dict[str, Any]] = None,
    headers: Optional[Dict[str, str]] = None,
    timeout: float = 15.0,
) -> Tuple[int, Dict[str, Any], bytes, Dict[str, str]]:
    """Execute an HTTP request and parse JSON response if present."""
    req_headers = {"User-Agent": "MinecraftLauncher/2.2.10675", "Accept": "application/json"}
    if headers:
        req_headers.update(headers)

    body_bytes = None
    if json_data is not None:
        req_headers["Content-Type"] = "application/json"
        body_bytes = json.dumps(json_data).encode("utf-8")
    elif data is not None:
        req_headers["Content-Type"] = "application/x-www-form-urlencoded"
        body_bytes = urllib.parse.urlencode(data).encode("utf-8")

    req = urllib.request.Request(url, data=body_bytes, headers=req_headers, method=method)

    try:
        with urllib.request.urlopen(req, timeout=timeout, context=_SSL_CONTEXT) as response:
            res_code = response.status
            res_headers = dict(response.headers)
            raw_data = response.read()
            try:
                parsed = json.loads(raw_data.decode("utf-8")) if raw_data else {}
            except Exception:
                parsed = {}
            return res_code, parsed, raw_data, res_headers
    except urllib.error.HTTPError as e:
        res_headers = dict(e.headers) if hasattr(e, "headers") else {}
        raw_data = e.read()
        try:
            parsed = json.loads(raw_data.decode("utf-8")) if raw_data else {}
        except Exception:
            parsed = {}
        return e.code, parsed, raw_data, res_headers
    except Exception as e:
        raise RuntimeError(f"Network error communicating with {url}: {e}") from e


@contextmanager
def lock_directory(dir_path: Path):
    """Acquire an exclusive kernel advisory lock on the directory."""
    dir_path.mkdir(parents=True, exist_ok=True)
    dir_fd = os.open(str(dir_path), os.O_RDONLY)
    try:
        try:
            import fcntl
            fcntl.flock(dir_fd, fcntl.LOCK_EX)
        except ImportError:
            pass
        yield
    finally:
        try:
            import fcntl
            fcntl.flock(dir_fd, fcntl.LOCK_UN)
        except (ImportError, OSError):
            pass
        os.close(dir_fd)


def atomic_write(file_path: Path, content: str, mode: int = 0o600) -> None:
    """Write content to a temporary file in the same directory and atomically rename."""
    file_path.parent.mkdir(parents=True, exist_ok=True)
    tmp_path = file_path.with_name(f".{file_path.name}.tmp.{os.getpid()}")

    flags = os.O_WRONLY | os.O_CREAT | os.O_TRUNC
    fd = os.open(tmp_path, flags, mode)
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            f.write(content)
        os.replace(tmp_path, file_path)
    except Exception:
        if tmp_path.exists():
            try:
                tmp_path.unlink()
            except OSError:
                pass
        raise


def read_file_safe(file_path: Path) -> Optional[str]:
    """Read file content safely, returning stripped string or None if unreadable."""
    if not file_path.exists():
        return None
    try:
        return file_path.read_text(encoding="utf-8").strip()
    except OSError:
        return None


def get_account_username(account_dir: Path) -> Optional[str]:
    """Read last known username for an account directory."""
    return read_file_safe(account_dir / "last-known-username")


def _device_code_login() -> Tuple[str, str]:
    """Initiate Microsoft Live OAuth Device Flow and poll until authorization succeeds."""
    code_status, code_res, _, headers = _http_request(
        "https://login.live.com/oauth20_connect.srf",
        method="POST",
        data={
            "client_id": CLIENT_ID,
            "scope": SCOPE,
            "response_type": "device_code",
        },
    )

    if code_status != 200 or "device_code" not in code_res:
        raise RuntimeError(f"Failed to initiate device login: {code_res}")

    user_code = code_res["user_code"]
    verification_uri = code_res.get("verification_uri", "https://www.microsoft.com/link")
    device_code = code_res["device_code"]
    interval = code_res.get("interval", 5)
    expires_in = code_res.get("expires_in", 900)

    set_cookie = headers.get("Set-Cookie", "")
    poll_headers = {"Cookie": set_cookie} if set_cookie else {}

    sys.stderr.write(f"To sign in, open {verification_uri} in a browser and enter code: {user_code}\n")
    sys.stderr.write("Waiting for authorization...\n")
    sys.stderr.flush()

    start_time = time.time()
    while time.time() - start_time < expires_in:
        time.sleep(interval)
        token_status, token_res, _, _ = _http_request(
            f"https://login.live.com/oauth20_token.srf?client_id={CLIENT_ID}",
            method="POST",
            headers=poll_headers,
            data={
                "client_id": CLIENT_ID,
                "device_code": device_code,
                "grant_type": "urn:ietf:params:oauth:grant-type:device_code",
            },
        )

        if token_status == 200 and "access_token" in token_res:
            sys.stderr.write("Authorization successful.\n")
            sys.stderr.flush()
            return token_res["access_token"], token_res["refresh_token"]

        err = token_res.get("error")
        if err == "authorization_pending":
            continue
        elif err == "slow_down":
            interval += 5
            continue
        elif err in ("expired_token", "authorization_declined"):
            raise RuntimeError(f"Device login failed: {err}")
        elif token_status >= 400:
            raise RuntimeError(f"Device login error: {token_res}")

    raise TimeoutError("Device authorization timed out.")


def _refresh_microsoft_token(refresh_token: str) -> Tuple[str, str]:
    """Exchange a Microsoft refresh token for new access and refresh tokens."""
    status, res, _, _ = _http_request(
        "https://login.live.com/oauth20_token.srf",
        method="POST",
        data={
            "client_id": CLIENT_ID,
            "scope": SCOPE,
            "grant_type": "refresh_token",
            "refresh_token": refresh_token,
        },
    )

    if status != 200 or "access_token" not in res:
        err_desc = res.get("error_description", res.get("error", "Unknown error"))
        raise RuntimeError(f"Failed to refresh Microsoft token: {err_desc}")

    return res["access_token"], res["refresh_token"]


def _exchange_for_minecraft_chain(ms_access_token: str) -> Tuple[str, int, str, str]:
    """
    Exchange Microsoft access token through Xbox Live (XAU), XSTS, and Minecraft services.
    Returns (mc_access_token, mc_expires_in, username, normalized_uuid).
    """
    rps_ticket = ms_access_token if (ms_access_token.startswith("d=") or ms_access_token.startswith("t=")) else f"t={ms_access_token}"

    # 1. Xbox Live User Authentication (XAU)
    xbl_status, xbl_res, _, _ = _http_request(
        "https://user.auth.xboxlive.com/user/authenticate",
        method="POST",
        headers={
            "Content-Type": "application/json",
            "Accept": "application/json",
            "x-xbl-contract-version": "2",
        },
        json_data={
            "Properties": {
                "AuthMethod": "RPS",
                "SiteName": "user.auth.xboxlive.com",
                "RpsTicket": rps_ticket,
            },
            "RelyingParty": "http://auth.xboxlive.com",
            "TokenType": "JWT",
        },
    )

    if xbl_status != 200 or "Token" not in xbl_res:
        raise RuntimeError(f"Xbox Live authentication failed (status {xbl_status}): {xbl_res}")

    xbl_token = xbl_res["Token"]
    try:
        user_hash = xbl_res["DisplayClaims"]["xui"][0]["uhs"]
    except (KeyError, IndexError) as e:
        raise RuntimeError(f"Malformed Xbox Live response: {xbl_res}") from e

    # 2. Xbox Secure Token Service (XSTS)
    xsts_status, xsts_res, _, _ = _http_request(
        "https://xsts.auth.xboxlive.com/xsts/authorize",
        method="POST",
        headers={
            "Content-Type": "application/json",
            "Accept": "application/json",
            "x-xbl-contract-version": "1",
        },
        json_data={
            "Properties": {
                "SandboxId": "RETAIL",
                "UserTokens": [xbl_token],
            },
            "RelyingParty": "rp://api.minecraftservices.com/",
            "TokenType": "JWT",
        },
    )

    if xsts_status != 200 or "Token" not in xsts_res:
        xerr = xsts_res.get("XErr")
        if xerr == 2148916233:
            raise RuntimeError("Xbox Live error: Account does not have an Xbox profile. Please create one at https://signup.live.com/signup")
        elif xerr == 2148916238:
            raise RuntimeError("Xbox Live error: Account date of birth is under 18 and requires Family setup.")
        raise RuntimeError(f"XSTS authorization failed (status {xsts_status}, XErr={xerr}): {xsts_res}")

    xsts_token = xsts_res["Token"]

    # 3. Minecraft Services Login
    mc_status, mc_res, _, _ = _http_request(
        "https://api.minecraftservices.com/authentication/login_with_xbox",
        method="POST",
        headers={
            "Content-Type": "application/json",
            "Accept": "application/json",
        },
        json_data={"identityToken": f"XBL3.0 x={user_hash};{xsts_token}"},
    )

    if mc_status != 200 or "access_token" not in mc_res:
        raise RuntimeError(f"Minecraft authentication failed (status {mc_status}): {mc_res}")

    mc_access_token = mc_res["access_token"]
    mc_expires_in = mc_res.get("expires_in", 86400)

    # 4. Fetch Minecraft Profile
    prof_status, prof_res, _, _ = _http_request(
        "https://api.minecraftservices.com/minecraft/profile",
        method="GET",
        headers={"Authorization": f"Bearer {mc_access_token}"},
    )

    if prof_status != 200 or "id" not in prof_res or "name" not in prof_res:
        raise RuntimeError(
            "Minecraft Java profile not found. If this is a new purchase, "
            "please visit https://www.minecraft.net/profile to set your in-game username first."
        )

    norm_uuid = normalize_uuid(prof_res["id"])
    return mc_access_token, mc_expires_in, prof_res["name"], norm_uuid


def verify_mc_token_live(mc_token: str) -> Optional[Tuple[str, str]]:
    """Verify Minecraft token against Mojang session servers. Returns (username, normalized_uuid) or None."""
    if not mc_token:
        return None

    try:
        status, res, _, _ = _http_request(
            "https://api.minecraftservices.com/minecraft/profile",
            method="GET",
            headers={"Authorization": f"Bearer {mc_token}"},
            timeout=6.0,
        )
        if status == 200 and "id" in res and "name" in res:
            return res["name"], normalize_uuid(res["id"])
    except Exception:
        pass
    return None


def get_all_account_dirs(auth_dir: Path) -> List[Path]:
    """Find all valid account directories under auth_dir."""
    if not auth_dir.exists():
        return []
    return sorted([
        p for p in auth_dir.iterdir()
        if p.is_dir() and (p / "refresh-token").exists()
    ])


def save_account_data(
    account_dir: Path,
    username: str,
    refresh_token: str,
    mc_token: str,
    mc_expires_in: int,
) -> None:
    """Save account tokens and username to flat files under <auth-dir>/<uuid>/."""
    account_dir.mkdir(parents=True, exist_ok=True)
    os.chmod(account_dir, 0o700)

    expires_at = int(time.time()) + mc_expires_in

    atomic_write(account_dir / "last-known-username", username)
    atomic_write(account_dir / "refresh-token", refresh_token)
    atomic_write(account_dir / "mc-token", mc_token)
    atomic_write(account_dir / "mc-token-expires", str(expires_at))


def refresh_account(account_dir: Path) -> Tuple[str, str, str]:
    """
    Refresh tokens under directory lock.
    Returns (mc_token, username, normalized_uuid).
    """
    uuid_str = account_dir.name
    stored_username = get_account_username(account_dir) or "Unknown"

    with lock_directory(account_dir):
        current_mc_token = read_file_safe(account_dir / "mc-token")
        expires_str = read_file_safe(account_dir / "mc-token-expires")

        if current_mc_token and expires_str:
            try:
                expires_at = int(expires_str)
                if time.time() < (expires_at - EXPIRY_BUFFER_SECONDS):
                    verified = verify_mc_token_live(current_mc_token)
                    if verified:
                        live_user, live_uuid = verified
                        if get_account_username(account_dir) != live_user:
                            atomic_write(account_dir / "last-known-username", live_user)
                        return current_mc_token, live_user, live_uuid
                    # Return cached token if local expiration timestamp is still valid
                    return current_mc_token, stored_username, uuid_str
            except ValueError:
                pass

        saved_refresh_token = read_file_safe(account_dir / "refresh-token")
        if not saved_refresh_token:
            raise RuntimeError(f"No refresh token found in {account_dir}.")

        try:
            new_ms_access_token, new_refresh_token = _refresh_microsoft_token(saved_refresh_token)
            new_mc_token, mc_expires_in, username, live_uuid = _exchange_for_minecraft_chain(new_ms_access_token)
            save_account_data(account_dir, username, new_refresh_token, new_mc_token, mc_expires_in)
            return new_mc_token, username, live_uuid
        except Exception as err:
            # Fallback to existing token if still unexpired
            if current_mc_token and expires_str:
                try:
                    if time.time() < int(expires_str):
                        return current_mc_token, stored_username, uuid_str
                except ValueError:
                    pass
            raise err


# ==============================================================================
# CLI Commands
# ==============================================================================

def cmd_auth(args: argparse.Namespace) -> int:
    """Special launcher command: checks/verifies credentials, auto-logins if missing/expired, outputs token or client args."""
    try:
        auth_dir: Path = args.auth_dir
        raw_uuid = args.uuid or os.environ.get("NIXCRAFT_CLIENT_AUTH_UUID", "").strip() or None
        target_uuid: Optional[str] = normalize_uuid(raw_uuid) if raw_uuid else None
        verify_username: Optional[str] = args.verify_username.strip() if args.verify_username else None

        account_dir: Optional[Path] = None
        if target_uuid:
            candidate = auth_dir / target_uuid
            if candidate.is_dir() and (candidate / "refresh-token").exists():
                account_dir = candidate

        mc_token: Optional[str] = None
        username: Optional[str] = None
        live_uuid: Optional[str] = None

        # 1. If UUID was provided and account directory exists on disk, try silent refresh
        if account_dir is not None:
            try:
                mc_token, username, live_uuid = refresh_account(account_dir)
            except Exception as err:
                sys.stderr.write(f"Cached credentials could not be refreshed ({err}). Re-authenticating...\n")
                account_dir = None

        # 2. If UUID was not given, or not on disk, or refresh failed: proceed to login
        if account_dir is None:
            if not target_uuid:
                sys.stderr.write(
                    "Warning: No --uuid was provided and NIXCRAFT_CLIENT_AUTH_UUID is not set. "
                    "Defaulting to interactive login...\n"
                )
            ms_access_token, ms_refresh_token = _device_code_login()
            sys.stderr.write("Authenticating with Minecraft services...\n")
            mc_token, mc_expires_in, username, live_uuid = _exchange_for_minecraft_chain(ms_access_token)

            # Check UUID match if UUID was specified
            if target_uuid and target_uuid != live_uuid:
                raise RuntimeError(
                    f"Fetched account UUID '{live_uuid}' does not match expected UUID '{target_uuid}'."
                )

            target_dir = auth_dir / live_uuid
            with lock_directory(target_dir):
                save_account_data(target_dir, username, ms_refresh_token, mc_token, mc_expires_in)

            sys.stderr.write(f"Logged in as {username} ({live_uuid})\n")
            sys.stderr.write(f"Account saved: {target_dir}\n")

        # 3. Verify in-game username if --verify-username was provided
        if verify_username and username.lower() != verify_username.lower():
            raise RuntimeError(
                f"Fetched account username '{username}' does not match provided username '{verify_username}'."
            )

        # 4. Format output to stdout
        if args.as_client_args:
            sys.stdout.write(f"--username {username} --uuid {live_uuid} --accessToken {mc_token}\n")
        else:
            sys.stdout.write(f"{mc_token}\n")
        sys.stdout.flush()
        return 0
    except Exception as e:
        sys.stderr.write(f"Error: {e}\n")
        return 1


def cmd_add_account(args: argparse.Namespace) -> int:
    """Explicit interactive device login to add a new account."""
    try:
        ms_access_token, ms_refresh_token = _device_code_login()
        sys.stderr.write("Authenticating with Minecraft services...\n")
        mc_access_token, mc_expires_in, username, live_uuid = _exchange_for_minecraft_chain(ms_access_token)

        account_dir = args.auth_dir / live_uuid
        with lock_directory(account_dir):
            save_account_data(account_dir, username, ms_refresh_token, mc_access_token, mc_expires_in)

        sys.stderr.write(f"Logged in as {username} ({live_uuid})\n")
        sys.stderr.write(f"Account saved: {account_dir}\n")
        return 0
    except Exception as e:
        sys.stderr.write(f"Error: {e}\n")
        return 1


def cmd_get_token(args: argparse.Namespace) -> int:
    """Get valid token for --uuid."""
    try:
        norm_uuid = normalize_uuid(args.uuid)
        account_dir = args.auth_dir / norm_uuid
        if not (account_dir.is_dir() and (account_dir / "refresh-token").exists()):
            raise RuntimeError(f"No account found with UUID '{args.uuid}' in auth directory: {args.auth_dir}")

        mc_token, _, _ = refresh_account(account_dir)
        sys.stdout.write(f"{mc_token}\n")
        sys.stdout.flush()
        return 0
    except Exception as e:
        sys.stderr.write(f"Error: {e}\n")
        return 1


def cmd_get_username(args: argparse.Namespace) -> int:
    """Get username for --uuid."""
    try:
        norm_uuid = normalize_uuid(args.uuid)
        account_dir = args.auth_dir / norm_uuid
        if not (account_dir.is_dir() and (account_dir / "refresh-token").exists()):
            raise RuntimeError(f"No account found with UUID '{args.uuid}' in auth directory: {args.auth_dir}")

        username = get_account_username(account_dir)
        if not username:
            _, username, _ = refresh_account(account_dir)

        if username:
            sys.stdout.write(f"{username}\n")
            sys.stdout.flush()
            return 0
        raise RuntimeError(f"Username not found for account with UUID '{args.uuid}'.")
    except Exception as e:
        sys.stderr.write(f"Error: {e}\n")
        return 1


def cmd_refresh(args: argparse.Namespace) -> int:
    """Refresh tokens for --uuid or --all."""
    try:
        auth_dir: Path = args.auth_dir

        if args.all:
            all_accs = get_all_account_dirs(auth_dir)
            if not all_accs:
                sys.stderr.write(f"No accounts found in auth directory: {auth_dir}\n")
                return 0
            for acc in all_accs:
                sys.stderr.write(f"Refreshing account {acc.name}...\n")
                _, username, live_uuid = refresh_account(acc)
                sys.stderr.write(f"✓ Refreshed token for {username} ({live_uuid})\n")
            return 0

        if args.uuid:
            norm_uuid = normalize_uuid(args.uuid)
            account_dir = auth_dir / norm_uuid
            if not (account_dir.is_dir() and (account_dir / "refresh-token").exists()):
                raise RuntimeError(f"No account found with UUID '{args.uuid}' in auth directory: {auth_dir}")

            sys.stderr.write(f"Refreshing account {account_dir.name}...\n")
            token, username, live_uuid = refresh_account(account_dir)
            sys.stderr.write(f"✓ Refreshed token for {username} ({live_uuid})\n")
            sys.stdout.write(f"{token}\n")
            sys.stdout.flush()
            return 0

        raise RuntimeError("Specify --uuid <uuid> or --all to refresh.")
    except Exception as e:
        sys.stderr.write(f"Error: {e}\n")
        return 1


def cmd_status(args: argparse.Namespace) -> int:
    """List all accounts and status."""
    auth_dir = args.auth_dir
    if not auth_dir.exists():
        sys.stderr.write(f"Auth directory does not exist: {auth_dir}\n")
        return 0

    subdirs = get_all_account_dirs(auth_dir)
    if not subdirs:
        sys.stderr.write(f"No accounts configured in {auth_dir}\n")
        return 0

    print(f"\nConfigured Accounts in {auth_dir}:")
    print("-" * 75)
    print(f"{'UUID':<34} {'Last Known Username':<22} {'Status':<15}")
    print("-" * 75)

    now = time.time()
    for acc in subdirs:
        uuid_str = acc.name
        username = get_account_username(acc) or "Unknown"
        expires_str = read_file_safe(acc / "mc-token-expires")

        status_str = "Expired"
        if expires_str:
            try:
                exp = int(expires_str)
                if exp > now:
                    remaining_min = int((exp - now) / 60)
                    status_str = f"Active ({remaining_min}m left)"
            except ValueError:
                pass

        print(f"{uuid_str:<34} {username:<22} {status_str:<15}")

    print("-" * 75 + "\n")
    return 0


def main() -> int:
    default_auth_dir = os.environ.get("NIXCRAFT_AUTH_DIR")

    parser = argparse.ArgumentParser(
        description="Nixcraft Minecraft Authentication Helper",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "--auth-dir",
        type=Path,
        default=Path(default_auth_dir) if default_auth_dir else None,
        required=default_auth_dir is None,
        help="Authentication directory (or set $NIXCRAFT_AUTH_DIR)",
    )

    subparsers = parser.add_subparsers(dest="command", required=True)

    # Subcommand: auth (launcher helper)
    sub_auth = subparsers.add_parser(
        "auth",
        help="Resolve credentials, auto-login if missing, verify against config, and output token or client launch args",
    )
    sub_auth.add_argument(
        "--uuid",
        type=str,
        default=None,
        help="Account player UUID to check and retrieve session for",
    )
    sub_auth.add_argument(
        "--verify-username",
        type=str,
        default=None,
        help="Verify that the account username matches this value",
    )
    sub_auth.add_argument(
        "--as-client-args",
        action="store_true",
        help="Output '--username <name> --uuid <uuid> --accessToken <token>' for Minecraft client arguments",
    )
    sub_auth.set_defaults(func=cmd_auth)

    # Subcommand: add-account (explicit login)
    sub_add = subparsers.add_parser(
        "add-account",
        aliases=["login"],
        help="Interactively authenticate a new Microsoft account and save it to the auth directory",
    )
    sub_add.set_defaults(func=cmd_add_account)

    # Subcommand: get-token
    sub_token = subparsers.add_parser(
        "get-token",
        help="Retrieve and print a valid Minecraft session token for a specific UUID",
    )
    sub_token.add_argument(
        "--uuid",
        type=str,
        required=True,
        help="Account player UUID",
    )
    sub_token.set_defaults(func=cmd_get_token)

    # Subcommand: get-username
    sub_uname = subparsers.add_parser(
        "get-username",
        help="Retrieve and print the last known in-game username for a specific UUID",
    )
    sub_uname.add_argument(
        "--uuid",
        type=str,
        required=True,
        help="Account player UUID",
    )
    sub_uname.set_defaults(func=cmd_get_username)

    # Subcommand: refresh
    sub_refresh = subparsers.add_parser(
        "refresh",
        help="Force refresh Minecraft session and OAuth tokens for a specific account or all accounts",
    )
    refresh_group = sub_refresh.add_mutually_exclusive_group(required=True)
    refresh_group.add_argument(
        "--uuid",
        type=str,
        help="Account player UUID to refresh",
    )
    refresh_group.add_argument(
        "--all",
        action="store_true",
        help="Refresh all accounts in auth-dir",
    )
    sub_refresh.set_defaults(func=cmd_refresh)

    # Subcommand: status
    sub_status = subparsers.add_parser(
        "status",
        help="Display a summary table of all stored accounts and token expiration states",
    )
    sub_status.set_defaults(func=cmd_status)

    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.stderr.write("\nAborted.\n")
        sys.exit(130)
    except Exception as err:
        sys.stderr.write(f"Error: {err}\n")
        sys.exit(1)
