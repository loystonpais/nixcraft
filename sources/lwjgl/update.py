#!/usr/bin/env python3
"""
Fetch LWJGL 2 and LWJGL 3 component metadata from Prism Launcher Meta
and store it in sources/lwjgl/lock.json
"""

import json
import sys
import urllib.request
from pathlib import Path

BASE_URL = "https://meta.prismlauncher.org/v1"


def fetch_json(url: str):
    req = urllib.request.Request(
        url,
        headers={
            "User-Agent": "nixcraft/1.0 (https://github.com/loystonpais/nixcraft)"
        },
    )
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read().decode("utf-8"))


def main():
    repo_path = Path("sources/lwjgl/lock.json")
    lock_path = repo_path if repo_path.parent.exists() else Path("lock.json")

    output = {}

    packages = ["org.lwjgl3", "org.lwjgl"]
    for pkg in packages:
        print(f"Fetching index for {pkg}...", file=sys.stderr)
        idx = fetch_json(f"{BASE_URL}/{pkg}/index.json")
        versions = idx.get("versions", [])

        for v in versions:
            v_name = v["version"]
            print(f"  Fetching {pkg} version {v_name}...", file=sys.stderr)
            url = f"{BASE_URL}/{pkg}/{v_name}.json"
            output[v_name] = fetch_json(url)

    print(f"Writing {len(output)} versions to {lock_path}...", file=sys.stderr)
    with open(lock_path, "w") as f:
        json.dump(output, f, indent=2)
        f.write("\n")
    print("Done!", file=sys.stderr)


if __name__ == "__main__":
    main()
