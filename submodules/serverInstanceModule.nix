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
  instanceDirPrefix,
  rootDir,
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
          "${config.java.finalArgumentShellString}"
          (escapeShellArg config._mainClass)
          (config.finalArgumentShellString)
        ];

      finalLaunchShellScript = ''
        #!${pkgs.bash}/bin/bash

        set -e

        ${lib.nixcraft.mkExportedEnvVars config.envVars}

        ${config.finalPreLaunchShellScript}

        cd "${config.absoluteDir}"

        exec ${config.finalLaunchShellCommandString} "$@"
      '';

      finalActivationShellScript = ''
        ${config.activationShellScript}
      '';

      finalPreLaunchShellScript = ''
        ${config.preLaunchShellScript}
      '';

      dir = lib.mkDefault "${instanceDirPrefix}/${config.name}";
      absoluteDir = "${rootDir}/${config.dir}";

      _instanceType = "server";

      mainJar = lib.mkDefault (
        fetchSha1 config.meta.versionData.downloads.server
      );

      paper.minecraftVersion = config.version;

      runtimeLibs = with pkgs; [udev];
    }

    (lib.mkIf config.paper.enable {
      mainJar = config.paper._serverJar;
      _mainClass = config.paper._mainClass;
    })

    (lib.mkIf config.fabricLoader.enable {
      _mainClass = config.fabricLoader.meta.serverMainClass;
    })

    (lib.mkIf config.quiltLoader.enable {
      _mainClass = config.quiltLoader.meta.lock.mainClass.server;
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
