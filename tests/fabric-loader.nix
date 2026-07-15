{
  lib,
  pkgs,
  sources,
  submodules,
}:
let
  evalFabricLoader = config:
    lib.evalModules {
      modules = [
        submodules.fabricLoaderModule
        config
      ];
  };

  loaderVersions = lib.attrNames sources.fabric.lock;
  defaultVersion = (evalFabricLoader {}).config.version;
  defaultIsLatest =
    builtins.elem defaultVersion loaderVersions
    && lib.all (version: builtins.compareVersions version defaultVersion <= 0) loaderVersions;
  explicitVersion = (evalFabricLoader {
    version = "0.16.14";
  }).config.version;
in
pkgs.runCommandLocal "nixcraft-fabric-loader-test" {} ''
  ${assert defaultIsLatest; ""}
  ${assert explicitVersion == "0.16.14"; ""}
  touch $out
''
