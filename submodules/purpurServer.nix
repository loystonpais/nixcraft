{
  lib,
  sources,
  pkgs,
  ...
}: {
  config,
  ...
}: {
  options = {
    enable = lib.mkEnableOption "Purpur";

    minecraftVersion =
      lib.nixcraft.options.minecraftVersionDyn
      // {
        defaultText = ''<inferred>'';
      };

    _serverJar = lib.mkOption {
      readOnly = true;
      type = lib.types.package;
      default = pkgs.fetchurl {
        inherit (config.meta.build) url hash;
      };
      defaultText = ''serverJar'';
    };

    meta = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      default = {
        build = sources.purpur.builds."${config.minecraftVersion}" or null;
      };
      defaultText = ''meta'';
    };
  };
}
