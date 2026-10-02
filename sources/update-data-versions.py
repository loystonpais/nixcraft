#!/usr/bin/env python3
"""
Updates sources/minecraft-data-versions.json.

Can be run with:
  1. No arguments: checks sources/version_manifest_v2.json for any version missing from
     sources/minecraft-data-versions.json, downloads their client.jar version.json, and appends them.
  2. <mc-version>: downloads and updates just the specified Minecraft version.
"""

import io
import json
import sys
import urllib.request
import zipfile
from pathlib import Path

SOURCES_DIR = Path("sources")
MANIFEST_FILE = SOURCES_DIR / "version_manifest_v2.json"
DATA_VERSIONS_FILE = SOURCES_DIR / "minecraft-data-versions.json"


def fetch_json(url: str):
    with urllib.request.urlopen(url) as resp:
        return json.load(resp)


def extract_data_version_from_client_jar(client_jar_url: str):
    req = urllib.request.Request(client_jar_url, headers={"User-Agent": "Nixcraft"})
    with urllib.request.urlopen(req) as resp:
        data = resp.read()
    zf = zipfile.ZipFile(io.BytesIO(data))
    if "version.json" in zf.namelist():
        v_data = json.loads(zf.read("version.json").decode("utf-8"))
        return v_data.get("world_version")
    return None


def update_version(version_id: str, version_url: str, data_versions: dict) -> bool:
    print(f"Fetching metadata for {version_id}...")
    v_meta = fetch_json(version_url)
    client_dl = v_meta.get("downloads", {}).get("client", {})
    client_jar_url = client_dl.get("url")
    if not client_jar_url:
        print(f"No client jar URL found for {version_id}")
        return False

    print(f"Downloading client jar for {version_id} and reading version.json...")
    world_ver = extract_data_version_from_client_jar(client_jar_url)
    if world_ver is not None:
        data_versions[version_id] = world_ver
        print(f"-> {version_id} = {world_ver}")
        return True
    else:
        print(f"version.json (or world_version) not found in client jar for {version_id}")
        return False


def main():
    if not DATA_VERSIONS_FILE.exists():
        data_versions = {}
    else:
        with open(DATA_VERSIONS_FILE, "r", encoding="utf-8") as f:
            data_versions = json.load(f)

    with open(MANIFEST_FILE, "r", encoding="utf-8") as f:
        manifest = json.load(f)

    manifest_versions = {v["id"]: v["url"] for v in manifest.get("versions", [])}

    target_versions = []
    if len(sys.argv) > 1:
        for arg in sys.argv[1:]:
            if arg in manifest_versions:
                target_versions.append((arg, manifest_versions[arg]))
            else:
                print(f"Warning: {arg} not found in version manifest")
    else:
        # DataVersion was introduced in 15w32a (2015-08-05). Older versions do not have it.
        cutoff = "2015-08-05T12:22:42+00:00"
        for v in manifest.get("versions", []):
            vid = v["id"]
            if vid not in data_versions and v.get("releaseTime", "") >= cutoff and vid != "1.8.9":
                target_versions.append((vid, v["url"]))

    if not target_versions:
        print("All versions in manifest are already up to date in minecraft-data-versions.json.")
        return 0

    print(f"Found {len(target_versions)} versions to update...")
    updated_count = 0
    for vid, url in target_versions:
        try:
            if update_version(vid, url, data_versions):
                updated_count += 1
        except Exception as e:
            print(f"Failed to fetch data version for {vid}: {e}")

    if updated_count > 0:
        with open(DATA_VERSIONS_FILE, "w", encoding="utf-8") as f:
            json.dump(data_versions, f, indent=2)
        print(f"Successfully updated {updated_count} version(s) in {DATA_VERSIONS_FILE}")
    else:
        print("No new data versions added.")

    return 0


if __name__ == "__main__":
    sys.exit(main())
