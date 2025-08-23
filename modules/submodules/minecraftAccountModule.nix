{lib, ...}: {
  name,
  config,
  ...
}: {
  options = {
    username = lib.mkOption {
      type = lib.types.str;
      default = name;
    };

    offline = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    uuid = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    accessTokenPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkMerge [
    {
      _module.check =
        lib.asserts.assertMsg (!(config.accessTokenPath != null && config.offline))
        "Offline accounts cannot have access token paths provided";
    }
  ];
}
