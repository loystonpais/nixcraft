# Waywall is a wayland compositor that runs minecraft. Used for mcsr (minecraft speedrunning)
{
  lib,
  fileModule,
  ...
}: {
  name,
  config,
  ...
}: {
  options = {
    enable = lib.mkEnableOption "waywall";

    package = lib.mkOption {
      type = lib.types.package;
    };

    profile = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      example = "foo";
      default = null;
    };

    configText = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      description = ''
        Lua script passed as init.lua
      '';
      default = null;
    };

    configDir = lib.mkOption {
      type = lib.types.nullOr (lib.types.pathWith {absolute = true;});
      description = ''
        Path to a dir containing waywall scripts such as init.lua
        If not set then $XDG_CONFIG_HOME/waywall is used as usual
      '';
      example = ''
        pkgs.linkFarm {
          "init.lua" = builtins.toFile "init.lua" "<content>";
        };
      '';
      default = null;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.configText != null) {
      profile = null;
    })

    # TODO: find correct way to do validations
    {
      _module.check = lib.all (a: a) [
        (
          lib.assertMsg
          ((lib.count (v: v != null) [
              config.configDir
              config.configText
            ])
            <= 1) "either .configText or .configDir needs to be set not both"
        )
      ];
    }
  ];
}
