{
  pkgs,
  fetchAssetFromHash,
  fetchSha1,
  lib,
  ...
}: {libraries}: let
  inherit (lib) pipe;
  inherit
    (lib.nixcraft.maven)
    filterLibrariesByOS
    filterClassifiers
    filterEmptyArtifactUrl
    toLibraryArtifactLinkTree
    ;

  os =
    if pkgs.stdenv.hostPlatform.isLinux then "linux"
    else if pkgs.stdenv.hostPlatform.isDarwin then "osx"
    else throw "Unsupported Minecraft OS: ${pkgs.stdenv.hostPlatform.system}";

  librariesLinkTree = pipe libraries [
    (filterLibrariesByOS os)
    filterClassifiers
    filterEmptyArtifactUrl
    (toLibraryArtifactLinkTree fetchSha1)
  ];
in
  pkgs.linkFarm "minecraft-lib-dir" librariesLinkTree
