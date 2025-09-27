{
  pkgs,
  lib,
  submodules,
  cfg ? {},
  name ? "default",
  ...
}: let
  clientInstanceModule = submodules.clientInstanceModule;

  evaluated = lib.evalModules {
    modules = [
      clientInstanceModule
      cfg
      {
        version = lib.mkDefault "latest-release";
        absoluteDir = lib.mkDefault "/tmp/nixcraft-client/${name}";
        account = lib.mkDefault {};
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
