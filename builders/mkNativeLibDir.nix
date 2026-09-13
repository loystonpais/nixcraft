{
  pkgs,
  fetchSha1,
  lib,
  ...
}: {
  normalizedLibraries ? null,
  versionDataLibraries ? null,
  runCommandLocal ? pkgs.runCommandLocal,
  unzip ? pkgs.unzip,
}: let
  inherit (lib) concatMapStringsSep;

  libs =
    if normalizedLibraries != null
    then normalizedLibraries
    else if versionDataLibraries != null
    then lib.nixcraft.maven.mkNormalizedMinecraftLibraryAttrs pkgs.stdenv.hostPlatform fetchSha1 versionDataLibraries
    else throw "mkNativeLibDir: either 'normalizedLibraries' or 'versionDataLibraries' must be provided";

  enabledNativeLibs =
    map (l: l.jar) (builtins.filter (l: l.enable && l.native) (builtins.attrValues libs));

  placeNativeLibs =
    concatMapStringsSep "\n" (nativeLibrary: ''
      unzip -o ${nativeLibrary} -d $out
    '')
    enabledNativeLibs;

  script = ''
    mkdir -p $out
    ${placeNativeLibs}
    rm -rf $out/META-INF
    rm -f $out/*.git
    rm -f $out/*.sha1
  '';
in
  runCommandLocal "minecraft-native-lib-dir" {
    nativeBuildInputs = [unzip];
  }
  script
