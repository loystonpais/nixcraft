{lib, ...}: {
  name,
  config,
  ...
}: {
  options = {
    offline = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether this account is offline (unauthenticated).";
    };

    uuid = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
      description = "Player UUID.";
    };

    username = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
      description = "Player username. For online accounts, used to verify against authenticated profile.";
    };
  };
}
