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
  unzip ? pkgs.unzip,
}: let
  inherit (lib) concatMapStringsSep;
  inherit (lib.nixcraft.maven) filterLibrariesByOS;

  # TODO: add support for osx
  artifacts = filterLibrariesByOS "linux" versionData.libraries;

  # Native libraries come zipped
  nativeLibrariesZippedList = map (
    artif: fetchSha1 artif.downloads.classifiers.${artif.natives.${"linux"}}
  ) (lib.filter (x: (x.downloads ? "classifiers")) artifacts);

  placeNativeLibs =
    concatMapStringsSep "\n" (nativeLibrary: ''
      unzip -o ${nativeLibrary} -d $out && rm -rf $out/META-INF
    '')
    nativeLibrariesZippedList;

  script = ''
    mkdir -p $out
    ${placeNativeLibs}
  '';
in
  runCommand "minecraft-native-lib-dir" {
    nativeBuildInputs = [unzip];
  }
  script
