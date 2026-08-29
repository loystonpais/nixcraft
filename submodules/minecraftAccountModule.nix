{lib, ...}: {
  name,
  config,
  ...
}: {
  options = {
    username = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = name;
    };

    offline = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    uuid = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
    };

    accessTokenPath = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
    };

    accessTokenBinPath = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
    };
  };

  config = lib.mkMerge [
    {
      _module.check = lib.all (a: a) [
        (
          lib.assertMsg (!(config.accessTokenPath != null && config.offline))
          "Offline accounts cannot have access token paths provided"
        )
        (
          lib.assertMsg (!(config.accessTokenBinPath != null && config.offline))
          "Offline accounts cannot have access token bin paths provided"
        )
        (
          lib.assertMsg
          ((lib.count (v: v != null) [
              config.accessTokenPath
              config.accessTokenBinPath
            ])
            <= 1)
          "Cannot provide both accessTokenPath and accessTokenBinPath at the same time"
        )
      ];
    }
  ];
}
