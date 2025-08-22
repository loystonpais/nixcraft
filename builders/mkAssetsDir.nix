# Generates an asset dir from objects from manifest (versionData)
{
  pkgs,
  fetchAssetFromHash,
  fetchSha1,
  lib,
  ...
}: {
  versionData,
  assetType ? versionData.assets,
  assetIndex ? lib.nixcraft.readJSON (fetchSha1 versionData.assetIndex),
  objects ? assetIndex.objects,
  runCommand ? pkgs.runCommand,
}: let
  inherit (builtins) attrValues mapAttrs toFile toJSON;
  inherit (lib) concatMapStringsSep;
  inherit (lib.nixcraft.manifest) mkAssetHashPath;

  # [ { src = ...; path = ...; } ...  ]
  assetsWithPath = attrValues (mapAttrs (name: asset: {
      src = fetchAssetFromHash {sha1 = asset.hash;};
      path =
        if versionData.assets == "legacy"
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
    ln -s ${toFile "assets.json" (toJSON assetIndex)} $out/indexes/${versionData.assets}.json
  '';

  script = ''
    ${placeAssets}
    ${placeAssetIndex}
  '';
in
  runCommand "minecraft-asset-dir" {} script
