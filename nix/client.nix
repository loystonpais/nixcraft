{
  config,
  lib,
  ...
} @ flakeArgs: let
  inherit (config.nixcraft) sources;
in {
  nixcraft.client.module = {
    config,
    dir ? "/(root)/.local/share/nixcraft/client/instances",
    authDirPrefix ? "/(root)/.local/share/nixcraft/client/auth",
    externalAssetsDirPrefix ? "/(root)/.local/share/nixcraft/client/assets",
    skinsDirPrefix ? "/(root)/.local/share/nixcraft/client/skins",
    externalAssetsLookupPaths ? [
      "/(root)/.local/share/PrismLauncher/assets"
      "/(root)/.minecraft/assets"
      "/var/cache/nixcraft/asset-objects"
    ],
    pkgs,
    moduleType ? "package",
    ...
  }: {
    options = {
      auth = {
        uuid = lib.mkOption {
          type = with lib.types; nullOr nonEmptyStr;
          default = null;
          description = "Default player UUID for client authentication.";
        };
      };

      instances = lib.mkOption {
        type = with lib.types;
          attrsOf (submoduleWith {
            modules = [
              flakeArgs.config.nixcraft.client.instance.module
            ];
            specialArgs = {
              inherit (config) shared;
              dirPrefix = "${config.dir}";
              readOnlyName = true;
              inherit
                authDirPrefix
                externalAssetsDirPrefix
                skinsDirPrefix
                externalAssetsLookupPaths
                pkgs
                moduleType
                ;
            };
          });
      };

      shared = lib.mkOption {
        type = with lib.types; attrs;
        default = {};
      };

      dir = lib.mkOption {
        type = lib.types.pathWith {absolute = true;};
        default = dir;
      };
    };
  };

  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    isImpure = builtins ? currentSystem;
    homeDir =
      if isImpure
      then builtins.getEnv "HOME"
      else "";
    hasHome = isImpure && homeDir != "";

    defaultExternalAssetsDirPrefix =
      if hasHome
      then "${homeDir}/.local/share/nixcraft/client/assets"
      else "/tmp/nixcraft-client-assets";

    defaultExternalAssetsLookupPaths =
      if hasHome
      then [
        "${homeDir}/.local/share/PrismLauncher/assets"
        "${homeDir}/.minecraft/assets"
        "/var/cache/nixcraft/asset-objects"
      ]
      else ["/var/cache/nixcraft/asset-objects"];

    defaultAuthDirPrefix =
      if hasHome
      then "${homeDir}/.local/share/nixcraft/client/auth"
      else "/tmp/nixcraft-client-auth";

    defaultSkinsDirPrefix =
      if hasHome
      then "${homeDir}/.local/share/nixcraft/client/skins"
      else "/tmp/nixcraft-client-skins";

    evalPackage = {cfgModules, ...}: let
      evaluated = lib.evalModules {
        modules =
          [
            flakeArgs.config.nixcraft.client.instance.module
            ({config, ...}: {
              version = lib.mkDefault "latest-release";
              absoluteDir = lib.mkDefault (
                if hasHome
                then "${homeDir}/.local/share/nixcraft/client/instances/${config.name}"
                else "/tmp/nixcraft-client/${config.name}"
              );
              account = lib.mkDefault {offline = true;};
              binEntry.enable = lib.mkDefault true;
              desktopEntry.enable = lib.mkDefault true;
            })
          ]
          ++ cfgModules;
        specialArgs = {
          shared = {};
          dirPrefix = null;
          readOnlyName = false;
          authDirPrefix = defaultAuthDirPrefix;
          externalAssetsDirPrefix = defaultExternalAssetsDirPrefix;
          skinsDirPrefix = defaultSkinsDirPrefix;
          externalAssetsLookupPaths = defaultExternalAssetsLookupPaths;
          inherit pkgs lib;
          name = "default";
          moduleType = "package";
        };
      };

      # Combines both bin entry and desktop entry
      finalEntry = pkgs.symlinkJoin {
        name = evaluated.config.binEntry.name;
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
      finalEntry;

    extraCombinators = withConfig: rec {
      withName = newName:
        withConfig {
          name = newName;
        };
      named = withName;

      withExternalAssets = withConfig {
        enableExternalAssets = true;
      };

      withExternalAssetsDir = dir:
        withConfig {
          enableExternalAssets = true;
          externalAssetsDir = dir;
        };

      withExternalAssetsExtraLookupPaths = paths:
        withConfig {
          enableExternalAssets = true;
          externalAssetsExtraLookupPaths = paths;
        };

      withAccount = account:
        withConfig {
          inherit account;
        };

      withOnlineAccount = withConfig {
        account.offline = false;
      };

      withOfflineAccount = username:
        withConfig {
          account = {
            offline = true;
            inherit username;
          };
        };

      withWaywall = withConfig {
        waywall.enable = true;
      };

      mcsr = withConfig {
        mcsr.enable = true;
      };
      withMcsr = mcsr;

      mcsrGlfw3-4 = withConfig {
        mcsr.enable = true;
        mcsr.glfwVersion = "3.4";
      };

      mcsrGlfw3-5-1 = withConfig {
        mcsr.enable = true;
        mcsr.glfwVersion = "3.5.1";
      };

      withBwrap = withConfig {
        bwrap.enable = true;
      };

      withLwjglVersion = version:
        withConfig {
          lwjgl.version = version;
        };

      rsg = withConfig {
        version = "1.16.1";
        fabricLoader = {
          enable = true;
          version = "0.15.11";
        };
        mcsr.enable = true;
        java = {
          extraArguments = [
            "-XX:+UseG1GC"
            "-XX:+UnlockExperimentalVMOptions"
            "-XX:G1NewSizePercent=20"
            "-XX:G1ReservePercent=20"
            "-XX:MaxGCPauseMillis=50"
            "-XX:G1HeapRegionSize=32m"
            "-Djdk.attach.allowAttachSelf=true"
          ];
          package = pkgs.jdk17;
          maxMemory = 4000;
          minMemory = 4000;
        };

        waywall.enable = true;

        binEntry = {
          name = "rsg";
        };

        desktopEntry = {
          name = "Nixcraft RSG";
          extraConfig = {
            terminal = true;
          };
        };
      };
    };
  in {
    packages.client = (flakeArgs.config.nixcraft.lib.makeInstancePackage {
      inherit sources evalPackage extraCombinators;
    }) {};
  };
}
