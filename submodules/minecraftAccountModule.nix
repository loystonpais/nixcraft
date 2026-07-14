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

    refreshTokenPath = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
    };
  };

  config = lib.mkMerge [
    {
      _module.check =
        lib.asserts.assertMsg (!(config.refreshTokenPath != null && config.offline))
        "Offline accounts cannot have refresh token paths provided";
    }
  ];
}
