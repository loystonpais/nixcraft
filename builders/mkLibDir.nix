{
  pkgs,
  fetchSha1,
  lib,
  ...
}: {
  normalizedLibraries ? null,
  versionDataLibraries ? null,
}: let
  libs =
    if normalizedLibraries != null
    then normalizedLibraries
    else if versionDataLibraries != null
    then lib.nixcraft.maven.mkNormalizedMinecraftLibraryAttrs pkgs.stdenv.hostPlatform fetchSha1 versionDataLibraries
    else throw "mkLibDir: either 'normalizedLibraries' or 'versionDataLibraries' must be provided";

  enabledNonNativeLibs = builtins.filter (
    l:
      l.enable && !l.native
  ) (builtins.attrValues libs);

  toLinkEntry = l: {
    name = l.relativePath;
    value = l.jar;
  };

  librariesLinkTree = builtins.listToAttrs (map toLinkEntry enabledNonNativeLibs);
in
  pkgs.linkFarm "minecraft-lib-dir" librariesLinkTree
