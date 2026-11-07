{
  config,
  lib,
  ...
} @ flakeArgs: let
  inherit (config.nixcraft) sources;
in {
  nixcraft.server.instance.module = {
    name,
    config,
    shared ? {},
    pkgs,
    ...
  }: {
    imports = [
      flakeArgs.config.nixcraft.instance.module
    ] ++ flakeArgs.config.nixcraft.server.instance.extensions;

      options = {
        enable =
          (lib.mkEnableOption "server instance")
          // {
            default = true;
          };

        _mainClass = lib.mkOption {
          type = lib.types.nonEmptyStr;
          internal = true;
          default = let
            inherit (flakeArgs.config.nixcraft.lib.minecraftVersion) ls;
          in
            # if settings.version < 1.17
            if ls config.version "1.17"
            then "net.minecraft.server.MinecraftServer"
            else "net.minecraft.bundler.Main";
        };

        noGui =
          (lib.mkEnableOption "no gui")
          // {
            default = true;
          };

        agreeToEula = lib.mkEnableOption "agree to EULA";

        finalArgumentShellString = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = with lib;
            escapeShellArgs (
              concatLists [
                (optional (config.noGui) "nogui")
                config.extraArguments
              ]
            );
        };

        serverProperties = lib.mkOption {
          type = with lib.types; nullOr (attrsOf (nullOr (oneOf [bool int str])));
          default = null;
        };

        world = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = ''
            Path to world dir. Only placed if the directory doesn't exist
          '';
        };

        service = lib.mkOption {
          type = with lib.types;
            submodule ({
              name,
              config,
              ...
            }: {
              options = {
                enable = lib.mkEnableOption "systemd user service";
                autoStart = lib.mkEnableOption "enables by default";
              };
            });
          default = {
            enable = false;
            autoStart = true;
          };
        };
      };

      config = lib.mkMerge [
        shared

        {
          libraries =
            lib.mapAttrs
            (_: libDef: lib.mkDefault libDef)
            (flakeArgs.config.nixcraft.lib.maven.mkNormalizedMinecraftLibraryAttrs
              pkgs.stdenv.hostPlatform
              pkgs
              config.meta.versionData.libraries);

          finalLaunchShellCommandString = with lib;
            concatStringsSep " " (concatLists [
              (flakeArgs.config.nixcraft.lib.mkLaunchPrefixList config.launchPrefix)
              [
                ''"${config.java.package}/bin/java"''
                config.java.finalArgumentShellString
                config.finalArgumentShellString
              ]
            ]);

          finalLaunchShellScript = ''
            #!${pkgs.bash}/bin/bash

            set -e

            ${flakeArgs.config.nixcraft.lib.mkExportedEnvVars config.envVars}

            ${config.finalPreLaunchShellScript}

            cd ${lib.escapeShellArg config.absoluteDir}

            ${
              if config.lazymc.enable
              then ''exec "${lib.getExe config.lazymc.package}" --config ${config.absoluteDir}/lazymc.toml''
              else ''exec ${config.finalLaunchShellCommandString} "$@"''
            }
          '';

          finalActivationShellScript = ''
            ${config.activationShellScript}
          '';

          finalPreLaunchShellScript = ''
            ${config.preLaunchShellScript}
          '';

          _instanceType = "server";

          mainJar = lib.mkDefault (
            pkgs.fetchurl {
              inherit (config.meta.versionData.downloads.server) url sha1;
            }
          );

          runtimeLibs = with pkgs; [udev];

          java.jar = lib.mkDefault config.mainJar;
          java.mainClass = lib.mkDefault null;
        }

        (lib.mkIf config.mrpack.enable {
          world = lib.mkDefault config.mrpack._parsedMrpack.world.overrides-plus-server-overrides;
        })

        (lib.mkIf config.agreeToEula {
          files."eula.txt".text = ''
            # Agreed using nixcraft config
            eula=true
          '';
        })

        (lib.mkIf (config.serverProperties != null) {
          files."server.properties" = {
            type = "properties";
            value = config.serverProperties;
            method = "merge";
          };
        })

        # Place world dir
        (lib.mkIf (config.world != null) {
          files."world" = {
            source = config.world;
            method = "world";
          };
        })

        # Validations
        (let
          prefixMsg = "instance '${config.name}'";
        in {
          _module.check = lib.all (a: a) [
            # Paper, Purpur, and Folia are alternative server implementations, not loaders to combine.
            (
              let
                enabledCount =
                  lib.count (x: x) [
                    config.paper.enable
                    config.purpur.enable
                    config.folia.enable
                  ];
              in
                lib.assertMsg (enabledCount <= 1)
                "${prefixMsg}: Only one of Paper, Purpur, or Folia can be enabled."
            )

            (
              lib.assertMsg ((config.paper.enable || config.purpur.enable || config.folia.enable)
                -> (
                  config.forgeLoader.enable == false
                  && config.neoForgeLoader.enable == false
                  && config.fabricLoader.enable == false
                  && config.quiltLoader.enable == false
                ))
              "${prefixMsg}: can't have Paper, Purpur, or Folia enabled while mod loaders are enabled."
            )
          ];
        })
      ];
    };
}
