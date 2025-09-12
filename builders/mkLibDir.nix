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

  # TODO: add support for osx
  librariesLinkTree = pipe libraries [
    (filterLibrariesByOS "linux")
    filterClassifiers
    filterEmptyArtifactUrl
    (toLibraryArtifactLinkTree fetchSha1)
  ];
in
  pkgs.linkFarm "minecraft-lib-dir" librariesLinkTree
