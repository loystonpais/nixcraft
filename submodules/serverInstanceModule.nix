{
  lib,
  pkgs,
  genericInstanceModule,
  paperServerModule,
  sources,
  fetchSha1,
  ...
}: {
  name,
  config,
  shared ? {},
  ...
}: {
  imports = [genericInstanceModule];

  options = {
    enable = lib.mkEnableOption "server instance";

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

    extraArguments = lib.mkOption {
      type = with lib.types; listOf nonEmptyStr;
      default = [];
    };

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
      finalLaunchShellCommandString = with lib;
        concatStringsSep " " [
          ''"${config.java.package}/bin/java"''
          config.java.finalArgumentShellString
          config.finalArgumentShellString
        ];

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
        fetchSha1 config.meta.versionData.downloads.server
      );

      paper.minecraftVersion = config.version;

      runtimeLibs = with pkgs; [udev];

      java.jar = lib.mkDefault config.mainJar;
      java.mainClass = lib.mkDefault null;

      lazymc.settings = {
        public.address = lib.mkDefault "0.0.0.0:25565";
        public.version = config.version;

        server.directory = config.absoluteDir;
        server.forge = config.forgeLoader.enable;
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

      # Lazymc overwrites a lotta things in server properties
      # so set it to copy instead of symlinking
      files."server.properties".method = lib.mkDefault "copy";
    })

    # Place world dir
    (lib.mkIf (config.world != null) (let
      esc = lib.escapeShellArg;
      absPlacePath = "${config.absoluteDir}/world";
    in {
      preLaunchShellScript = ''
        if [ ! -d ${esc absPlacePath} ]; then
          rm -rf ${esc absPlacePath}
          cp -R ${esc config.world} ${esc absPlacePath}
          chmod -R u+w ${esc absPlacePath}
        fi
      '';
    }))

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
              && config.fabricLoader.enable == false
              && config.quiltLoader.enable == false
            ))
          "${prefixMsg}: can't have paper server enabled while mod loaders are enabled."
        )
      ];
    })
  ];
}
