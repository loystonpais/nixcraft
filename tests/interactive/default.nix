{
  pkgs,
  lib,
  submodules,
}: let
  inherit (submodules) clientInstanceModule nixcraftModule;

  evaluated = lib.evalModules {
    modules = [
      nixcraftModule
      ./config.nix
    ];

    specialArgs = {
      clientDirPrefix = "/tmp/nixcraft-tests/nixcraft/client/instances";
      serverDirPrefix = "/tmp/nixcraft-tests/nixcraft/server/instances";
      inherit pkgs;
      inherit lib;
    };
  };

  clientInstances = evaluated.config.client.instances;

  script = ''
    clear
    echo "In this test we manually go through all the instances and see if they work or not"
    read

    echo "Testing client instances"
    read

    ${
      lib.concatMapAttrsStringSep "\n" (name: attrs: ''
        echo "Testing instance ${name}"
        ${lib.getExe attrs.binEntry.finalBin} 1> /dev/null || true
      '')
      clientInstances
    }
  '';
in
  pkgs.writeShellScriptBin "nixcraft-tests-interactive" script
