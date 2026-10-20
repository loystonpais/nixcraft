{
  lib,
  pkgs,
  genericInstanceModule,
  paperServerModule,
  sources,
  ...
}: {
  name,
  config,
  shared ? {},
  ...
}: {
  imports = [genericInstanceModule];

  options = {
    enable =
      (lib.mkEnableOption "server instance")
      // {
        default = true;
      };

    paper = lib.mkOption {
      type = lib.types.submodule paperServerModule;
      default = {
        enable = false;
      };
    };

    _mainClass = lib.mkOption {
      type = lib.types.nonEmptyStr;
      internal = true;
      default = let
        inherit (lib.nixcraft.minecraftVersion) ls;
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

    lazymc = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "lazymc";
          package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.lazymc;
          };
          settings = lib.mkOption {
            type = lib.types.attrs;
            default = {};
          };
        };
      };
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
        (lib.nixcraft.maven.mkNormalizedMinecraftLibraryAttrs
          pkgs.stdenv.hostPlatform
          pkgs
          config.meta.versionData.libraries);

      finalLaunchShellCommandString = with lib;
        concatStringsSep " " (concatLists [
          (lib.nixcraft.mkLaunchPrefixList config.launchPrefix)
          [
            ''"${config.java.package}/bin/java"''
            config.java.finalArgumentShellString
            config.finalArgumentShellString
          ]
        ]);

      finalLaunchShellScript = ''
        #!${pkgs.bash}/bin/bash

        set -e

        ${lib.nixcraft.mkExportedEnvVars config.envVars}

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

      paper.minecraftVersion = config.version;

      runtimeLibs = with pkgs; [udev];

      java.jar = lib.mkDefault config.mainJar;
      java.mainClass = lib.mkDefault null;

      lazymc.settings = {
        public.address = lib.mkDefault "0.0.0.0:25565";
        public.version = config.version;

        server.directory = config.absoluteDir;
        server.forge = config.forgeLoader.enable || config.neoForgeLoader.enable;
        server.command = config.finalLaunchShellCommandString;

        config.version = lib.mkDefault "0.2.11";
      };
    }

    (lib.mkIf config.paper.enable {
      java.mainClass = lib.mkForce null;
      java.jar = config.mainJar;
      mainJar = config.paper._serverJar;
    })

    (lib.mkIf config.fabricLoader.enable {
      java.jar = lib.mkForce null;
      java.mainClass = config.fabricLoader.meta.serverMainClass;
    })

    (lib.mkIf config.quiltLoader.enable {
      java.jar = lib.mkForce null;
      java.mainClass = config.quiltLoader.meta.lock.mainClass.server;
    })

    # Forge / NeoForge
    (let
      loader =
        if config.forgeLoader.enable
        then config.forgeLoader
        else config.neoForgeLoader;
    in
      lib.mkIf (config.forgeLoader.enable || config.neoForgeLoader.enable) (lib.mkMerge [
        {
          java.jar = lib.mkForce null;
        }

        # Legacy Forge: LaunchWrapper with the vanilla server jar on the classpath
        (lib.mkIf loader.meta.isLegacy {
          java.mainClass = loader.legacy.serverMainClass;
        })

        # Installer based: install once with the official installer, then launch
        # the generated args file / jar
        (lib.mkIf (!loader.meta.isLegacy) {
          java.mainClass = lib.mkForce null;
          java.cp = lib.mkForce [];
          java.extraArguments = lib.mkAfter loader.meta.server.javaArguments;

          preLaunchShellScript = ''
            mkdir -p ${lib.escapeShellArg config.absoluteDir}
            if [ ! -e ${lib.escapeShellArg "${config.absoluteDir}/${loader.meta.server.installMarker}"} ]; then
              echo "Installing ${loader.version} server..."
              (cd ${lib.escapeShellArg config.absoluteDir} && \
                ${lib.escapeShellArg "${config.java.package}/bin/java"} -jar ${lib.escapeShellArg loader.installerJar} \
                  --installServer ${lib.escapeShellArg config.absoluteDir})
            fi
          '';
        })
      ]))

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

    (lib.mkIf config.lazymc.enable {
      files."lazymc.toml" = {
        type = "toml";
        value = config.lazymc.settings;
      };

      serverProperties = {
        max-tick-time = -1;
      };

      # Lazymc overwrites settings in server properties
      files."server.properties".method = lib.mkDefault "merge";
    })

    # Place world dir
    (lib.mkIf (config.world != null) {
      files."world" = {
        source = config.world;
        method = "world";
      };
    })

    # TODO: find correct way to do validations
    (let
      prefixMsg = "instance '${config.name}'";
    in {
      _module.check = lib.all (a: a) [
        # if paper is enabled along with other mod loaders then fail
        (
          lib.assertMsg (config.paper.enable
            -> (
              config.forgeLoader.enable
              == false
              && config.neoForgeLoader.enable == false
              && config.fabricLoader.enable == false
              && config.quiltLoader.enable == false
            ))
          "${prefixMsg}: can't have paper server enabled while mod loaders are enabled."
        )

        (
          lib.assertMsg (config.paper.enable -> (builtins.elem config.paper.minecraftVersion sources.paper.versions))
          "${prefixMsg}: Paper server does not support Minecraft version '${config.paper.minecraftVersion}'."
        )
      ];
    })
  ];
}
