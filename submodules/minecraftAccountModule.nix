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

    oauth = lib.mkOption {
      type = with lib.types;
        nullOr (submodule {
          options = {
            tokenEndpoint = lib.mkOption {
              type = lib.types.nullOr lib.types.nonEmptyStr;
              default = null;
            };

            clientId = lib.mkOption {
              type = lib.types.nullOr lib.types.nonEmptyStr;
              default = null;
            };

            redirectUri = lib.mkOption {
              type = lib.types.nullOr lib.types.nonEmptyStr;
              default = null;
            };

            scope = lib.mkOption {
              type = lib.types.nullOr lib.types.nonEmptyStr;
              default = null;
            };
          };
        });
      default = null;
    };
  };

  config = lib.mkMerge [
    {
      _module.check =
        lib.asserts.assertMsg (!(config.refreshTokenPath != null && config.offline))
        "Offline accounts cannot have refresh token paths provided"
        && lib.asserts.assertMsg (!(config.oauth != null && config.offline))
        "Offline accounts cannot have OAuth configuration provided"
        && lib.asserts.assertMsg (
          config.oauth == null || config.refreshTokenPath != null
        )
        "Accounts using OAuth configuration must set refreshTokenPath"
        && lib.asserts.assertMsg (
          config.refreshTokenPath == null || config.oauth != null
        )
        "Accounts using refreshTokenPath must set oauth"
        && lib.asserts.assertMsg (
          config.refreshTokenPath == null || config.oauth.clientId != null
        )
        "Accounts using refreshTokenPath must set oauth.clientId"
        && lib.asserts.assertMsg (
          config.refreshTokenPath == null || config.oauth.tokenEndpoint != null
        )
        "Accounts using refreshTokenPath must set oauth.tokenEndpoint"
        && lib.asserts.assertMsg (
          config.refreshTokenPath == null || config.oauth.redirectUri != null
        )
        "Accounts using refreshTokenPath must set oauth.redirectUri"
        && lib.asserts.assertMsg (
          config.refreshTokenPath == null || config.oauth.scope != null
        )
        "Accounts using refreshTokenPath must set oauth.scope";
    }
  ];
}
