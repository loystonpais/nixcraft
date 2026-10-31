{
  lib,
  ...
} @ flakeArgs: {
  nixcraft.module = {
    name,
    config,
    clientDirPrefix ? "/(root)/.local/share/nixcraft/client/instances",
    clientAuthDirPrefix ? "/(root)/.local/share/nixcraft/client/auth",
    serverDirPrefix ? "/(root)/.local/share/nixcraft/server/instances",
    clientExternalAssetsDirPrefix ? "/(root)/.local/share/nixcraft/client/assets",
    clientSkinsDirPrefix ? null,
    clientExternalAssetsLookupPaths ? [
      "/(root)/.local/share/PrismLauncher/assets"
      "/(root)/.minecraft/assets"
      "/var/cache/nixcraft/asset-objects"
    ],
    pkgs,
    moduleType ? "package",
    ...
  }: {
    options = {
      enable = lib.mkEnableOption name;

      client = lib.mkOption {
        type = lib.types.submoduleWith {
          modules = [flakeArgs.config.nixcraft.client.module];
          specialArgs = {
            dir = clientDirPrefix;
            authDirPrefix = clientAuthDirPrefix;
            externalAssetsDirPrefix = clientExternalAssetsDirPrefix;
            skinsDirPrefix = clientSkinsDirPrefix;
            externalAssetsLookupPaths = clientExternalAssetsLookupPaths;
            inherit pkgs moduleType;
          };
        };
      };

      server = lib.mkOption {
        type = lib.types.submoduleWith {
          modules = [flakeArgs.config.nixcraft.server.module];
          specialArgs = {
            dir = serverDirPrefix;
            inherit pkgs moduleType;
          };
        };
      };

      activationShellScript = lib.mkOption {
        type = lib.types.lines;
      };

      finalActivationShellScript = lib.mkOption {
        type = lib.types.lines;
        readOnly = true;
        default = ''
          # Nixcraft activation script
          ${config.activationShellScript}
        '';
      };
    };

    config = lib.mkMerge [
      {
        activationShellScript = lib.concatMapAttrsStringSep "\n" (name: instance: instance.finalActivationShellScript) config.client.instances;
      }

      {
        activationShellScript = lib.concatMapAttrsStringSep "\n" (name: instance: instance.finalActivationShellScript) config.server.instances;
      }
    ];
  };
}
