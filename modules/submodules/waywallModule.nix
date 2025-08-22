{lib, ...}: {
  name,
  config,
  ...
}: {
  options = {
    enable = lib.mkEnableOption "waywall";

    package = lib.mkOption {
      type = lib.types.package;
    };
  };
}
