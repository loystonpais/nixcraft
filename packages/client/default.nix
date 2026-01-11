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
        binEntry.enable = lib.mkDefault true;
        desktopEntry.enable = lib.mkDefault true;
      }
    ];
    specialArgs = {
      shared = {};
      dirPrefix = null;
      inherit name;
      inherit pkgs;
      inherit lib;
    };
  };

  # Combines both bin entry and desktop entry
  finalEntry = pkgs.symlinkJoin {
    name = name;
    paths = [
      (
        pkgs.makeDesktopItem (evaluated.config.desktopEntry.extraConfig
          // {
            exec = "${lib.getExe evaluated.config.binEntry.finalBin}";
            desktopName = evaluated.config.desktopEntry.name;
            name = evaluated.config.binEntry.name;
          })
      )
      evaluated.config.binEntry.finalBin
    ];

    meta.mainProgram = evaluated.config.binEntry.name;

    passthru = {
      evaluatedModule = evaluated;
    };
  };
in
  finalEntry
