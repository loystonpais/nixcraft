{
  lib,
  genericInstanceSettingsModule,
  sources,
  fetchSha1,
  ...
}: {
  name,
  config,
  ...
}: {
  options = {
    enable = lib.mkEnableOption "server instance";

    settings = lib.mkOption {
      type = lib.types.submodule genericInstanceSettingsModule;
    };

    _serverJar = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = fetchSha1 config.settings.meta.versionData.downloads.server;
    };

    _mainClass = lib.mkOption {
      type = lib.types.str;
    };

    noGui =
      (lib.mkEnableOption "no gui")
      // {
        default = true;
      };

    agreeToEula = lib.mkEnableOption "agreen to EULA";

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
  };

  config = lib.mkMerge [
    {
      # Set the instance name from attr
      settings.name = lib.mkOptionDefault name;

      # inform generic settings module the instance type
      settings._instanceType = "server";

      # set the default main class
      # ? Apparently the server main class is not found in manifest
      # ? so lets hardcode it
      # ? the server jar file is a bundle which
      # ? is why a different class name is used as opposed to net.minecraft.server.Main
      # TODO: make it net.minecraft.server.Main for versions older than 1.17
      _mainClass = lib.mkDefault "net.minecraft.bundler.Main";

      # # not do this # settings.java.extraArguments = ["-jar" "${config._serverJar}"];
      #
      settings.java.cp = ["${config._serverJar}"];
    }

    (lib.mkIf config.settings.fabricLoader.enable {
      # set fabric's main class
      _mainClass = config.settings.fabricLoader.meta.serverMainClass;
    })

    # If user agrees to EULA
    (lib.mkIf config.agreeToEula {
      settings.dirFiles."eula.txt".text = ''
        # Agreed using nixcraft config
        eula=true
      '';
    })
  ];
}
