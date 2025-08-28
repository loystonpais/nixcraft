#!/usr/bin/env python3

# Minecraft's asset manifest uses SHA-1, which is not supported by builtins.fetchurl
# (it only supports SHA-256). While pkgs.fetchurl does support SHA-1, it creates a
# derivation internally, which adds unnecessary overhead. To avoid this, we generate
# a mapping of asset paths to their corresponding SHA-512 hashes, allowing us to
# use builtins.fetchurl.

import os
import sys
import hashlib
import base64
import json
import re


def nix_sha256_sri(filepath: str):
    with open(filepath, "rb") as f:
        m = hashlib.file_digest(f, "sha256")
    digest = base64.b64encode(m.digest()).decode("utf-8")
    return f"sha256-{digest}"


def hash_directory(root: str):
    result: dict[str, str] = {}
    for dirpath, _, filenames in os.walk(root):
        for name in filenames:
            full_path = os.path.join(dirpath, name)
            rel_path = os.path.relpath(full_path, root)

            sha256 = nix_sha256_sri(full_path)
            result[rel_path] = sha256
    return result


def validate_assets_objects_dir(path: str) -> bool:
    # Check for directories with 2-character names (hex prefix) and files with 40-char names (SHA-1)
    if not os.path.isdir(path):
        return False

    for entry in os.scandir(path):
        if entry.is_dir() and re.fullmatch(r"[a-f0-9]{2}", entry.name):
            subdir = os.path.join(path, entry.name)
            for subentry in os.scandir(subdir):
                if subentry.is_file() and re.fullmatch(r"[a-f0-9]{40}", subentry.name):
                    return True
    return False


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <path/to/assets/objects>", file=sys.stderr)
        print(
            "Example: On linux if you are using prism launcher\n"
            "  python scripts/update-asset-sha256.py ~/.local/share/PrismLauncher/assets/objects"
        )
        sys.exit(1)

    directory = sys.argv[1]
    if not validate_assets_objects_dir(directory):
        print(
            f"Error: {directory} does not look like a valid Minecraft assets/objects directory",
            file=sys.stderr,
        )
        sys.exit(1)

    output_file = "sources/asset-sha256.json"

    # Load existing data if file exists
    existing_data: dict[str, str] = {}
    if os.path.exists(output_file):
        with open(output_file, "r") as f:
            existing_data = json.load(f)

    prev_count = len(existing_data)

    new_data = hash_directory(directory)

    existing_data.update(new_data)

    new_count = len(existing_data)

    print(f"Added {new_count - prev_count} new assets")

    with open(output_file, "w") as f:
        json.dump(existing_data, f, indent=2)
