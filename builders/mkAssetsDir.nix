# Generates an asset dir from objects from manifest (versionData)
{
  pkgs,
  fetchAssetFromHash,
  fetchAssetsPy,
  fetchSha1,
  lib,
  ...
}: {
  useFetchAssetsPy ? false,
  hash ? lib.fakeHash,
  versionData,
  assetType ? versionData.assets,
  assetIndex ? lib.nixcraft.readJSON (fetchSha1 versionData.assetIndex),
  objects ? assetIndex.objects,
  runCommandLocal ? pkgs.runCommandLocal,
  fetchAssetsPyArgs ? {},
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
    runCommandLocal "minecraft-asset-dir" {} ''
      ${placeAssets}
      ${placeAssetIndex}
    '';

  fetchAssetsPyDownload = fetchAssetsPy ({
    name = "minecraft-asset-dir-py";
    indexFile = fetchSha1 versionData.assetIndex;
    inherit hash assetType;
  } // fetchAssetsPyArgs);
in
  if useFetchAssetsPy
  then fetchAssetsPyDownload
  else defaultDownload
