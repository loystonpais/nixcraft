# Generates an asset dir from objects from manifest (versionData)
{
  pkgs,
  fetchAssetFromHash,
  fetchAssetsPy,
  fetchSha1,
  lib,
  ...
}: {
  useExternalAssetsDir ? false,
  externalAssetsDir ? null,
  useFetchAssetsPy ? false,
  hash ? lib.fakeHash,
  versionData,
  assetType ? versionData.assets,
  assetIndex ? lib.nixcraft.readJSON (fetchSha1 versionData.assetIndex),
  objects ? assetIndex.objects,
  runCommandLocal ? pkgs.runCommandLocal,
  fetchAssetsPyArgs ? {},
}: let
  inherit (builtins) attrValues mapAttrs;
  inherit (lib) concatMapStringsSep escapeShellArg;
  inherit (lib.nixcraft.manifest) mkAssetHashPath;

  isLegacy = assetType == "legacy" || (assetIndex ? virtual && assetIndex.virtual);
  isPre1-6 = assetType == "pre-1.6" || (assetIndex ? map_to_resources && assetIndex.map_to_resources);

  objectsDownloadMethods = {
    default = let
      assetsWithPath = attrValues (mapAttrs (name: asset: {
          src = fetchAssetFromHash {sha1 = asset.hash;};
          path = "objects/${mkAssetHashPath asset.hash}";
        })
        objects);

      placeAssets =
        concatMapStringsSep "\n" (asset: ''
          mkdir -p "$out/${dirOf asset.path}"
          ln -sf ${asset.src} "$out/${asset.path}"
        '')
        assetsWithPath;
    in
      runCommandLocal "minecraft-asset-objects" {} ''
        ${placeAssets}
      '';

    viaFetchAssetsPy = fetchAssetsPy ({
        name = "minecraft-asset-objects-py";
        indexFile = fetchSha1 versionData.assetIndex;
        inherit hash;
      }
      // fetchAssetsPyArgs);
  };

  objectsDrv =
    if useFetchAssetsPy
    then objectsDownloadMethods.viaFetchAssetsPy
    else objectsDownloadMethods.default;

  finalObjectsPath =
    if useExternalAssetsDir
    then "${externalAssetsDir}/objects"
    else "${objectsDrv}/objects";

  assetsDir = runCommandLocal "minecraft-assets-dir" {} ''
    mkdir -p $out/indexes
    ln -s ${fetchSha1 versionData.assetIndex} $out/indexes/${assetType}.json
    ln -s ${escapeShellArg finalObjectsPath} $out/objects
  '';

  legacyAssetsDir = runCommandLocal "minecraft-legacy-assets-dir" {} ''
    mkdir -p $out

    ${concatMapStringsSep "\n" (name: let
      asset = objects.${name};
      path = mkAssetHashPath asset.hash;
    in ''
      mkdir -p "$out/${dirOf name}"
      ln -s ${escapeShellArg "${finalObjectsPath}/${path}"} "$out/${name}"
    '') (builtins.attrNames objects)}
  '';

  pre1-6AssetsDir = runCommandLocal "minecraft-pre-1.6-assets-dir" {} ''
    mkdir -p $out

    ${concatMapStringsSep "\n" (name: let
      asset = objects.${name};
      path = mkAssetHashPath asset.hash;
    in ''
      mkdir -p "$out/${dirOf name}"
      ln -s ${escapeShellArg "${finalObjectsPath}/${path}"} "$out/${name}"
    '') (builtins.attrNames objects)}
  '';
in
  if isLegacy
  then legacyAssetsDir
  else if isPre1-6
  then pre1-6AssetsDir
  else assetsDir
