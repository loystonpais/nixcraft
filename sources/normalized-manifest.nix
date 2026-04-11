# Generate a normalized versions attr
# { "1.16.1" = ...; "1.21.4" = ...; ... }
{lib, ...}: let
  inherit (builtins) listToAttrs filter;
  manifest = lib.nixcraft.readJSON ./version_manifest_v2.json;
in rec {
  versions' = listToAttrs (
    map (versionInfo: {
      name = versionInfo.id;
      value = versionInfo;
    })
    manifest.versions
  );

  versions =
    versions'
    // {
      latest-release = versions'.${manifest.latest.release};
      latest-snapshot = versions'.${manifest.latest.snapshot};
    };

  versionListOrdered = lib.nixcraft.versionManifestV2.getAllVersions manifest;

  # Index: versions grouped by type (release/snapshot) for WHERE-style filtering
  versionsByType = let
    groupBy = type: filter (v: v.type == type) manifest.versions;
  in {
    release = groupBy "release";
    snapshot = groupBy "snapshot";
  };

  # Index: ordered list of release version IDs
  releaseVersionsOrdered = map (v: v.id) versionsByType.release;

  # Index: ordered list of snapshot version IDs
  snapshotVersionsOrdered = map (v: v.id) versionsByType.snapshot;

  # Index: version lookup by sha1 for JOIN-style operations
  versionsBySha1 = listToAttrs (
    map (versionInfo: {
      name = versionInfo.sha1;
      value = versionInfo;
    })
    manifest.versions
  );
}
