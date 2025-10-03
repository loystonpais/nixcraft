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
      type = lib.types.nonEmptyStr;
      default = lib.last (builtins.attrNames (config.meta.builds));
      defaultText = ''<inferred>'';
    };

    minecraftVersion =
      lib.nixcraft.options.minecraftVersionDyn
      // {
        defaultText = ''<inferred>'';
      };

    _serverJar = lib.mkOption {
      readOnly = true;
      type = lib.types.package;
      default = pkgs.fetchurl {
        url = config.meta.builds.${config.buildNumber}.url;
        sha256 = config.meta.builds.${config.buildNumber}.sha256;
      };
      defaultText = ''serverJar'';
    };

    _mainClass = lib.mkOption {
      readOnly = true;
      type = lib.types.nonEmptyStr;
      default = config.meta.mainClass;
      defaultText = ''<inferred>'';
    };

    meta = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      default = {
        builds = sources.paper-servers."${config.minecraftVersion}";
        mainClass = "io.papermc.paperclip.Paperclip";
      };
      defaultText = ''meta'';
    };
  };
}
