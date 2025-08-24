{
  fetchSha1,
  sources,
  pkgs,
  lib,
  ...
}: {
  sha1,
  assetSha256 ? sources.asset-sha256,
}: let
  assetHashPath = lib.nixcraft.manifest.mkAssetHashPath sha1;
  url =
    "https://resources.download.minecraft.net/" + assetHashPath;
  src =
    if assetSha256 ? "${assetHashPath}"
    then
      builtins.fetchurl {
        inherit url;
        sha256 = assetSha256."${assetHashPath}";
      }
    else
      fetchSha1 {
        inherit url;
        inherit sha1;
      };
in
  src
