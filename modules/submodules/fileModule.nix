{
  lib,
  pkgs,
  ...
}: {
  name,
  config,
  ...
}: {
  options = {
    enable = (lib.mkEnableOption name) // {default = true;};

    target = lib.mkOption {
      type = lib.types.str;
      default = name;
    };

    mutable = lib.mkEnableOption "mutability";

    source = lib.mkOption {
      type = lib.types.path;
    };

    text = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.text != null) {
      source = pkgs.writeText "${config.target}" config.text;
    })
  ];
}
