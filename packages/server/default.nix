{
  pkgs,
  lib,
  submodules,
  config ? {},
  name ? "minecraft-server",
  ...
}: let
  serverInstanceModule = submodules.serverInstanceModule;

  evaluated = lib.evalModules {
    modules = [
      serverInstanceModule
      config
      {
        version = lib.mkDefault "latest-version";
      }
    ];
    specialArgs = {
      shared = {};
      dirPrefix = null;
      inherit name;
    };
  };
in
  # For some reason, passing just the finalBin doesn't work???
  pkgs.writeShellScriptBin "minecraft-server" ''
    ${lib.getExe evaluated.config.binEntry.finalBin}
  ''
