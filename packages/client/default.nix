{
  pkgs,
  lib,
  submodules,
  config ? {},
  name ? "nixcraft",
  ...
}: let
  clientInstanceModule = submodules.clientInstanceModule;

  evaluated = lib.evalModules {
    modules = [
      clientInstanceModule
      config
    ];
    specialArgs = {
      shared = {};
      dirPrefix = null;
      inherit name;
    };
  };
in
  # pkgs.writeShellScriptBin "foo" (builtins.trace evaluated.config.binEntry.finalBin "")
  pkgs.writeShellScriptBin "minecraft" ''
    ${lib.getExe evaluated.config.binEntry.finalBin}
  ''
