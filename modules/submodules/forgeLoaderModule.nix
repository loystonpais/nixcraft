{lib, ...}: {
  name,
  config,
  ...
}: {
  options = {
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
