{
  pkgs,
  lib,
  submodules,
  cfg ? {},
  name ? "default",
  ...
}: let
  serverInstanceModule = submodules.serverInstanceModule;

  evaluated = lib.evalModules {
    modules = [
      serverInstanceModule
      cfg
      {
        version = lib.mkDefault "latest-release";
        absoluteDir = lib.mkDefault "/tmp/nixcraft-server/${name}";
      }
    ];
    specialArgs = {
      shared = {};
      dirPrefix = null;
      inherit name;
    };
  };
in
  evaluated.config.binEntry.finalBin
