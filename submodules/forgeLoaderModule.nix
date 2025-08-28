{lib, ...}: {
  name,
  config,
  ...
}: {
  options = {
    enable = lib.mkEnableOption "forge loader";

    version = lib.mkOption {
      type = lib.types.str;
    };

    minecraftVersion = lib.mkOption {
      type = lib.types.str;
    };

    hash = lib.mkOption {
      type = lib.types.str;
      default = lib.fakeHash;
    };
  };
}
