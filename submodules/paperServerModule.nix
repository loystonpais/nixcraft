{
  lib,
  sources,
  pkgs,
  ...
}: {
  name,
  config,
  ...
}: {
  options = {
    enable = lib.mkEnableOption "paper";

    buildNumber = lib.mkOption {
      type = lib.types.str;
      default = lib.last (builtins.attrNames (config.meta.builds));
    };

    minecraftVersion = lib.nixcraft.options.minecraftVersionDyn;

    _serverJar = lib.mkOption {
      readOnly = true;
      type = lib.types.package;
      default = pkgs.fetchurl {
        url = config.meta.builds.${config.buildNumber}.url;
        sha256 = config.meta.builds.${config.buildNumber}.sha256;
      };
    };

    _mainClass = lib.mkOption {
      readOnly = true;
      type = lib.types.str;
      default = config.meta.mainClass;
    };

    meta = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      default = {
        builds = sources.paper-servers."${config.minecraftVersion}";
        mainClass = "io.papermc.paperclip.Paperclip";
      };
    };
  };
}
