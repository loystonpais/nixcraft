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
  inherit (lib) concatMapStringsSep;
  inherit (lib.nixcraft.manifest) filterArtifacts;

  # TODO: add support for osx
  artifacts = filterArtifacts "linux" versionData.libraries;

  # [ { src = ...; path = ...; } ...  ]
  librariesListWithPath = map (
    artif: {
      src = fetchSha1 artif.downloads.artifact;
      path = artif.downloads.artifact.path;
    }
  ) (lib.filter (x: !(x.downloads ? "classifiers")) artifacts);

  placeClient = ''
    mkdir -p $out
    ln -s ${client} $out/client.jar
  '';

  placeLibs =
    concatMapStringsSep "\n" (library: ''
      mkdir -p $out
      mkdir -p $out/${dirOf library.path}
      ln -s ${library.src} $out/${library.path}
    '')
    librariesListWithPath;

  client = fetchSha1 versionData.downloads.client;

  script = ''
    ${placeClient}
    ${placeLibs}
  '';
in
  runCommand "minecraft-lib-dir" {} script
