# Generates an asset dir from objects from manifest (versionData)
{
  pkgs,
  fetchAssetFromHash,
  fetchAria2c,
  fetchSha1,
  lib,
  ...
}: {
  useAria2c ? false,
  hash ? lib.fakeHash,
  versionData,
  assetType ? versionData.assets,
  assetIndex ? lib.nixcraft.readJSON (fetchSha1 versionData.assetIndex),
  objects ? assetIndex.objects,
  runCommand ? pkgs.runCommand,
}: let
  inherit (builtins) attrValues mapAttrs toFile toJSON;
  inherit (lib) concatMapStringsSep;
  inherit (lib.nixcraft.manifest) mkAssetHashPath;

  defaultDownload = let
    # [ { src = ...; path = ...; } ...  ]
    assetsWithPath = attrValues (mapAttrs (name: asset: {
        src = fetchAssetFromHash {sha1 = asset.hash;};
        path =
          if assetType == "legacy"
          then "virtual/legacy/${name}"
          else "objects/${mkAssetHashPath asset.hash}";
      })
      objects);

    placeAssets =
      concatMapStringsSep "\n" (asset: ''
        mkdir -p $out/${dirOf asset.path}
        ln -sf ${asset.src} $out/${asset.path}
      '')
      assetsWithPath;

    placeAssetIndex = ''
      mkdir -p $out/indexes
      ln -s ${fetchSha1 versionData.assetIndex} $out/indexes/${assetType}.json
    '';
  in
    runCommand "minecraft-asset-dir" {} ''
      ${placeAssets}
      ${placeAssetIndex}
    '';

  ariaDownload = let
    assetEntries = attrValues (mapAttrs (name: asset: let
        path =
          if assetType == "legacy"
          then "./virtual/legacy/${name}"
          else "./objects/${mkAssetHashPath asset.hash}";
      in {
        urls = ["https://resources.download.minecraft.net/${(mkAssetHashPath asset.hash)}"];
        out = baseNameOf path;
        dir = dirOf path;
      })
      objects);

    indexEntry = {
      urls = [versionData.assetIndex.url];
      out = "${assetType}.json";
      dir = "./indexes";
    };

    entries = [indexEntry] ++ assetEntries;
  in
    fetchAria2c {
      name = "minecraft-asset-dir-aria";
      inherit entries;
      inherit hash;
    };
in
  if useAria2c
  then ariaDownload
  else defaultDownload
