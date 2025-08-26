{
  lib,
  genericInstanceModule,
  paperServerModule,
  sources,
  fetchSha1,
  ...
}: {
  name,
  config,
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

    _serverJar = lib.mkOption {
      type = lib.types.package;
      internal = true;
      default = fetchSha1 config.meta.versionData.downloads.server;
    };

    _mainClass = lib.mkOption {
      type = lib.types.str;
      internal = true;
      default = let
        inherit (lib.nixcraft.minecraftVersion) ls;
      in
        # if settings.version < 1.17
        if ls config.version.value "1.17"
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
      type = with lib.types; listOf str;
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

    launchShellCommandString = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = with lib;
        concatStringsSep " " [
          ''"${config.java.package}/bin/java"''
          "${config.java.finalArgumentShellString}"
          (escapeShellArg config._mainClass)
          (config.finalArgumentShellString)
        ];
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
    {
      name = lib.mkOptionDefault name;
      _instanceType = "server";
      java.cp = ["${config._serverJar}"];

      paper.minecraftVersion = config.version.value;
    }

    (lib.mkIf config.paper.enable {
      _serverJar = config.paper._serverJar;
      _mainClass = config.paper._mainClass;
    })

    (lib.mkIf config.fabricLoader.enable {
      _mainClass = config.fabricLoader.meta.serverMainClass;
    })

    (lib.mkIf config.agreeToEula {
      dirFiles."eula.txt".text = ''
        # Agreed using nixcraft config
        eula=true
      '';
    })

    (lib.mkIf (config.serverProperties != null) {
      dirFiles."server.properties".text = lib.nixcraft.toMinecraftServerProperties config.serverProperties;
    })

    # TODO: find correct way to do validations
    (let
      prefixMsg = "instance '${config.name}'";
    in {
      _module.check = lib.all (a: a) [
        # if paper is enabled along with other mod loaders then fail
        (
          lib.assertMsg (config.paper.enable -> (config.forgeLoader.enable == false && config.fabricLoader.enable == false))
          "${prefixMsg}: can't have paper server enabled while mod loaders are enabled."
        )
      ];
    })
  ];
}
