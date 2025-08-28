mkdir -p sources

echo "Fetching Minecraft version manifest..."
curl -fsSL https://piston-meta.mojang.com/mc/game/version_manifest_v2.json \
  -o sources/version_manifest_v2.json

echo "Saved latest version manifest to sources/version_manifest_v2.json"
