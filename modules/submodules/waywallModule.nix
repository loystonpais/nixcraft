# Waywall is a wayland compositor that runs minecraft. Used for mcsr (minecraft speedrunning)
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
