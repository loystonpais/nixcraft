{
  fetchSha1,
  sources,
  pkgs,
  lib,
  ...
}: {
  sha1,
  assetSha256 ? sources.asset-sha256,
  useBuiltinFetch ? false,
}: let
  assetHashPath = lib.nixcraft.manifest.mkAssetHashPath sha1;
  url =
    "https://resources.download.minecraft.net/" + assetHashPath;
  src =
    if useBuiltinFetch && (assetSha256 ? "${assetHashPath}")
    then
      builtins.fetchurl {
        inherit url;
        sha256 = assetSha256."${assetHashPath}";
      }
    else
      (pkgs.fetchurl {
        inherit url;
        inherit sha1;
        preferLocalBuild = true;
      }).overrideAttrs {
        allowSubstitutes = false;
      };
in
  src
