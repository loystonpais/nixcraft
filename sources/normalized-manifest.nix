# Generate a normalized versions attr
# { "1.16.1" = ...; "1.21.4" = ...; ... }
{lib, ...}: let
  inherit (builtins) listToAttrs;
  manifest = lib.nixcraft.readJSON ./version_manifest_v2.json;
in {
  versions = listToAttrs (
    map (versionInfo: {
      name = versionInfo.id;
      value = versionInfo;
    })
    manifest.versions
  );

  versionListOrdered = lib.nixcraft.versionManifestV2.getAllVersions manifest;
}
