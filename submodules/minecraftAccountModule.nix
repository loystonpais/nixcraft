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

    accessTokenCommand = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
    }
  };

  config = lib.mkMerge [
    {
      _module.check = [
        (lib.asserts.assertMsg (!(config.accessTokenPath != null && config.offline))
          "Offline accounts cannot have access token paths provided")

        (lib.asserts.assertMsg (!(config.accessTokenPath != null && config.accessTokenCommand != null))
          "Access token path and access token command cannot both be set")
      ];
    }
  ];
}
