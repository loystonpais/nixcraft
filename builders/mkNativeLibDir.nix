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
  runCommandLocal ? pkgs.runCommandLocal,
  unzip ? pkgs.unzip,
}: let
  inherit (lib) concatMapStringsSep;

  platform = pkgs.stdenv.hostPlatform;

  nativeClassifierCandidates =
    if platform.system == "aarch64-darwin"
    then [
      "natives-macos-arm64"
      "natives-osx-arm64"
      "natives-macos"
      "natives-osx"
    ]
    else if platform.system == "x86_64-darwin"
    then [
      "natives-macos"
      "natives-osx"
    ]
    else if platform.system == "aarch64-linux"
    then [
      "natives-linux-arm64"
      "natives-linux"
    ]
    else if platform.system == "x86_64-linux"
    then [
      "natives-linux"
    ]
    else throw "Unsupported Minecraft native platform: ${platform.system}";

    nativeDownload = artif: let
      classifiers = artif.downloads.classifiers or {};
      matches = lib.filter (classifier: classifiers ? ${classifier}) nativeClassifierCandidates;
    in
      if matches == []
      then null
      else classifiers.${builtins.head matches};

    nativeLibrariesZippedList =
      map fetchSha1
        (
          lib.filter (x: x != null)
            (map nativeDownload versionData.libraries)
        );

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
  runCommandLocal "minecraft-native-lib-dir" {
    nativeBuildInputs = [unzip];
  }
  script
