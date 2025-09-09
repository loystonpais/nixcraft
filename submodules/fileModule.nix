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
      type = lib.types.pathWith {absolute = false;};
      default = name;
    };

    method = lib.mkOption {
      type = lib.types.enum ["copy" "copy-init" "symlink"];
      default = "symlink";
      description = ''
        Method to place the file in target location
          copy-init     - copy once during init (suitable for config files from modpacks)
          copy          - copy every rebuild
          symlink - symlink every rebuild
      '';
    };

    force = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Overwrite previously existing file/symlink/dir
      '';
    };

    source = lib.mkOption {
      type = lib.types.path;
    };

    text = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.text != null) {
      source = pkgs.writeText "${config.target}" config.text;
    })
  ];
}
