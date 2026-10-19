{
  sources,
  pkgs,
  lib,
  ...
}: {
  sha1,
  assetSha256Map ? sources.asset-sha1-sha256-map,
  useBuiltinFetch ? false,
}: let
  assetHashPath = lib.nixcraft.manifest.mkAssetHashPath sha1;
  url =
    "https://resources.download.minecraft.net/" + assetHashPath;
  src =
    if useBuiltinFetch && (assetSha256Map ? "${sha1}")
    then
      builtins.fetchurl {
        inherit url;
        sha256 = assetSha256Map."${sha1}";
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
