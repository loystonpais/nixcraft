#!/usr/bin/env python3
"""
Nixcraft File Merge Utility

Usage: nixcraft-file-merge <format> <json-patch> <base> <output>
"""

import argparse
import configparser
import json
import os
import sys
import time
from pathlib import Path
from typing import Any, Dict, Tuple


def atomic_write(target: Path, content: str, mode: int = 0o644) -> None:
    """Atomically writes content to target file via temporary file replacement."""
    target.parent.mkdir(parents=True, exist_ok=True)
    if target.is_symlink():
        target.unlink()

    tmp = target.with_name(f".{target.name}.tmp_{os.getpid()}_{time.time_ns()}")
    try:
        tmp.write_text(content, encoding="utf-8")
        tmp.chmod(mode)
        os.replace(tmp, target)
    finally:
        if tmp.exists():
            try:
                tmp.unlink()
            except OSError:
                pass


def _format_scalar(val: Any) -> str:
    """Formats a primitive value to string suitable for properties/options/ini."""
    if isinstance(val, bool):
        return "true" if val else "false"
    if val is None:
        return ""
    return str(val)


def _unpack_directive(node: Any) -> Tuple[str, Any]:
    """
    Checks if a node is a __nixcraft_file_merge directive.
    Returns (action, value).
    If not a directive, action is 'merge' (default recursive merge).
    """
    if isinstance(node, dict) and "__nixcraft_file_merge" in node:
        action = node.get("action", "force")
        value = node.get("value")
        return action, value
    return "merge", node


def _apply_structured_node(target: Any, key: Any, node: Any) -> None:
    """
    Applies a patch node to target container (dict, tomlkit Table/Document, ruamel.yaml mapping).
    Honors: force, remove, keep, append, or default recursive merge.
    """
    action, val = _unpack_directive(node)

    if action == "remove":
        if key in target:
            try:
                del target[key]
            except Exception:
                pass
        return

    if action == "keep":
        if key in target:
            return
        target[key] = val
        return

    if action == "force":
        target[key] = val
        return

    if action == "append":
        if key not in target:
            target[key] = val if isinstance(val, list) else [val]
        elif isinstance(target[key], list):
            if isinstance(val, list):
                target[key].extend(val)
            else:
                target[key].append(val)
        return

    # Default merge
    if key in target and hasattr(target[key], "items") and isinstance(val, dict):
        for sub_k, sub_v in val.items():
            _apply_structured_node(target[key], sub_k, sub_v)
    else:
        target[key] = val


def merge_options_txt(base: Path, patch_dict: Dict[str, Any], output: Path) -> None:
    """Merges Minecraft options.txt (key:value format) with directives."""
    directives = {str(k): _unpack_directive(v) for k, v in patch_dict.items()}

    base_lines = (
        base.read_text(encoding="utf-8").splitlines()
        if (base.exists() and base.stat().st_size > 0)
        else []
    )
    applied_keys = set()
    out_lines = []

    for line in base_lines:
        line_str = line.strip()
        if ":" in line and not line_str.startswith("#"):
            k, old_val = line.split(":", 1)
            k_clean = k.strip()
            if k_clean in directives:
                action, val = directives[k_clean]
                applied_keys.add(k_clean)
                if action == "remove":
                    continue
                elif action == "keep":
                    out_lines.append(line)
                elif action == "append":
                    out_lines.append(
                        f"{k_clean}:{old_val.strip()}{_format_scalar(val)}"
                    )
                else:  # force or merge
                    out_lines.append(f"{k_clean}:{_format_scalar(val)}")
            else:
                out_lines.append(line)
        else:
            out_lines.append(line)

    for k, (action, val) in directives.items():
        if k not in applied_keys and action != "remove":
            out_lines.append(f"{k}:{_format_scalar(val)}")

    atomic_write(output, "\n".join(out_lines) + "\n")


def merge_properties(base: Path, patch_dict: Dict[str, Any], output: Path) -> None:
    """Merges Java properties / server.properties (key=value format) with directives."""
    directives = {str(k): _unpack_directive(v) for k, v in patch_dict.items()}

    base_lines = (
        base.read_text(encoding="utf-8").splitlines()
        if (base.exists() and base.stat().st_size > 0)
        else []
    )
    applied_keys = set()
    out_lines = []

    for line in base_lines:
        line_str = line.strip()
        if "=" in line and not (line_str.startswith("#") or line_str.startswith("!")):
            k, old_val = line.split("=", 1)
            k_clean = k.strip()
            if k_clean in directives:
                action, val = directives[k_clean]
                applied_keys.add(k_clean)
                if action == "remove":
                    continue
                elif action == "keep":
                    out_lines.append(line)
                elif action == "append":
                    out_lines.append(
                        f"{k_clean}={old_val.strip()}{_format_scalar(val)}"
                    )
                else:  # force or merge
                    out_lines.append(f"{k_clean}={_format_scalar(val)}")
            else:
                out_lines.append(line)
        else:
            out_lines.append(line)

    for k, (action, val) in directives.items():
        if k not in applied_keys and action != "remove":
            out_lines.append(f"{k}={_format_scalar(val)}")

    atomic_write(output, "\n".join(out_lines) + "\n")


def merge_json(base: Path, patch_dict: Dict[str, Any], output: Path) -> None:
    """Deep merges JSON objects with directives."""
    if base.exists() and base.stat().st_size > 0:
        raw_base = base.read_text(encoding="utf-8")
        try:
            base_data = json.loads(raw_base)
            if not isinstance(base_data, dict):
                base_data = {}
        except Exception:
            base_data = {}
    else:
        base_data = {}

    for k, v in patch_dict.items():
        _apply_structured_node(base_data, k, v)

    atomic_write(output, json.dumps(base_data, indent=2) + "\n")


def merge_toml(base: Path, patch_dict: Dict[str, Any], output: Path) -> None:
    """Deep merges TOML documents preserving comments with directives."""
    import tomlkit

    if base.exists() and base.stat().st_size > 0:
        try:
            doc = tomlkit.parse(base.read_text(encoding="utf-8"))
        except Exception:
            doc = tomlkit.document()
    else:
        doc = tomlkit.document()

    for k, v in patch_dict.items():
        _apply_structured_node(doc, k, v)

    atomic_write(output, doc.as_string())


def merge_yaml(base: Path, patch_dict: Dict[str, Any], output: Path) -> None:
    """Deep merges YAML documents preserving comments with directives."""
    from io import StringIO
    from ruamel.yaml import YAML

    yaml = YAML()
    yaml.preserve_quotes = True

    if base.exists() and base.stat().st_size > 0:
        try:
            base_data = yaml.load(base.read_text(encoding="utf-8"))
            if not hasattr(base_data, "items"):
                base_data = {}
        except Exception:
            base_data = {}
    else:
        base_data = {}

    for k, v in patch_dict.items():
        _apply_structured_node(base_data, k, v)

    stream = StringIO()
    yaml.dump(base_data, stream)
    atomic_write(output, stream.getvalue())


def merge_ini(base: Path, patch_dict: Dict[str, Any], output: Path) -> None:
    """Merges INI files section by section with directives."""
    cfg = configparser.ConfigParser(interpolation=None)
    if base.exists() and base.stat().st_size > 0:
        cfg.read(base, encoding="utf-8")

    for sec, sec_node in patch_dict.items():
        sec_action, sec_val = _unpack_directive(sec_node)

        if sec_action == "remove":
            cfg.remove_section(sec)
            continue

        if sec_action == "keep":
            if cfg.has_section(sec):
                continue
            cfg.add_section(sec)
            if isinstance(sec_val, dict):
                for k, v in sec_val.items():
                    _, opt_v = _unpack_directive(v)
                    cfg.set(sec, str(k), _format_scalar(opt_v))
            continue

        if sec_action == "force":
            if cfg.has_section(sec):
                cfg.remove_section(sec)
            cfg.add_section(sec)
            if isinstance(sec_val, dict):
                for k, v in sec_val.items():
                    _, opt_v = _unpack_directive(v)
                    cfg.set(sec, str(k), _format_scalar(opt_v))
            continue

        # Normal section merge
        if not cfg.has_section(sec):
            cfg.add_section(sec)

        if isinstance(sec_val, dict):
            for opt, opt_node in sec_val.items():
                opt_action, opt_v = _unpack_directive(opt_node)
                if opt_action == "remove":
                    cfg.remove_option(sec, opt)
                elif opt_action == "keep":
                    if not cfg.has_option(sec, opt):
                        cfg.set(sec, str(opt), _format_scalar(opt_v))
                elif opt_action == "append":
                    curr = cfg.get(sec, opt, fallback="")
                    cfg.set(sec, str(opt), f"{curr}{_format_scalar(opt_v)}")
                else:  # force or merge
                    cfg.set(sec, str(opt), _format_scalar(opt_v))

    from io import StringIO

    stream = StringIO()
    cfg.write(stream)
    atomic_write(output, stream.getvalue())


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Nixcraft config file merge utility",
        usage="%(prog)s <format> <json-patch> <base> <output>",
    )
    parser.add_argument(
        "format",
        choices=["options-txt", "properties", "json", "toml", "yaml", "ini"],
        help="Configuration file format",
    )
    parser.add_argument(
        "json_patch",
        type=Path,
        help="JSON patch file path containing configuration updates",
    )
    parser.add_argument(
        "base",
        type=Path,
        help="Base configuration file path",
    )
    parser.add_argument(
        "output",
        type=Path,
        help="Output configuration file path",
    )
    args = parser.parse_args()

    fmt: str = args.format
    json_patch_path: Path = args.json_patch
    base: Path = args.base
    output: Path = args.output

    if not json_patch_path.exists():
        sys.stderr.write(f"Error: JSON patch file does not exist: {json_patch_path}\n")
        return 1

    try:
        patch_dict = json.loads(json_patch_path.read_text(encoding="utf-8"))
    except Exception as err:
        sys.stderr.write(
            f"Error: Failed to parse JSON patch file {json_patch_path}: {err}\n"
        )
        return 1

    if not isinstance(patch_dict, dict):
        sys.stderr.write(
            f"Error: JSON patch root must be an object (dict), got {type(patch_dict).__name__}\n"
        )
        return 1

    # If output is currently a symlink, break it to avoid modifying the read-only store
    if output.is_symlink():
        output.unlink()

    if fmt == "options-txt":
        merge_options_txt(base, patch_dict, output)
    elif fmt == "properties":
        merge_properties(base, patch_dict, output)
    elif fmt == "json":
        merge_json(base, patch_dict, output)
    elif fmt == "toml":
        merge_toml(base, patch_dict, output)
    elif fmt == "yaml":
        merge_yaml(base, patch_dict, output)
    elif fmt == "ini":
        merge_ini(base, patch_dict, output)

    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(130)
    except Exception as err:
        sys.stderr.write(f"Error merging config: {err}\n")
        sys.exit(1)
