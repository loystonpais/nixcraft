{lib, ...}: {
  name,
  config,
  ...
}: {
  options = {
    enable = lib.mkEnableOption "forge loader";

    version = lib.mkOption {
      type = lib.types.nonEmptyStr;
    };

    minecraftVersion = lib.nixcraft.options.minecraftVersionDyn;

    hash = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = lib.fakeHash;
    };
  };
}
