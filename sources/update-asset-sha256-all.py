import os
import json
import urllib.request
import hashlib
import base64
from pathlib import Path
from time import sleep

RESOURCE_URL_BASE = "https://resources.download.minecraft.net"

def nix_sha256_sri_from_bytes(data: bytes) -> str:
    m = hashlib.sha256(data).digest()
    digest = base64.b64encode(m).decode("utf-8")
    return f"sha256-{digest}"

def asset_hash_path(sha1: str) -> str:
    return sha1[:2] + "/" + sha1

def fetch_json(url: str):
    with urllib.request.urlopen(url) as r:
        return json.load(r)

def fetch_file(url: str):
    with urllib.request.urlopen(url) as r:
        return r.read()

SOURCES_DIR = Path("sources")
ASSET_SHA_FILE = SOURCES_DIR / "asset-sha256.json"
MANIFEST_FILE = SOURCES_DIR / "version_manifest_v2.json"

asset_sha_256 = json.load(open(ASSET_SHA_FILE))

old_count = len(asset_sha_256)


version_manifest = json.load(open(MANIFEST_FILE))


assets_to_download = set()

for version in version_manifest["versions"]:

    version_id = version["id"]
    version_url = version["url"]

    print(f"Working on {version_id}")

    version_data = fetch_json(version_url)
    asset_index = fetch_json(version_data["assetIndex"]["url"])
    objects = asset_index["objects"]

    for asset_path, asset_data in objects.items():
        hash = asset_data["hash"]
        asset_path = asset_hash_path(hash)

        if asset_path not in asset_sha_256:
          assets_to_download.add(asset_path)

    print(f"Successfully fetched asset urls from {version_id}")

for asset_path in assets_to_download:
  url = RESOURCE_URL_BASE + "/" + asset_path

  print(f"Downloading... {url}")

  filebytes = fetch_file(url)
  file_hash_256 = nix_sha256_sri_from_bytes(filebytes)

  asset_sha_256[asset_path] = file_hash_256

new_count = len(asset_sha_256)

print(f"Added {new_count - old_count} assets")
with open(ASSET_SHA_FILE, "w") as f:
        json.dump(asset_sha_256, f, indent=2)