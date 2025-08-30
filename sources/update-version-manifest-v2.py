import os
import json
import urllib.request

url = "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"
output_path = "sources/version_manifest_v2.json"

print("Fetching Minecraft version manifest...")

# Download and parse JSON
with urllib.request.urlopen(url) as response:
    data = json.load(response)

# Save formatted JSON
with open(output_path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print(f"Saved latest version manifest to {output_path}")
