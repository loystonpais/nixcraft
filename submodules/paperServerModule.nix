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
      type = lib.types.either lib.types.int lib.types.nonEmptyStr;
      default = config.meta.build.build;
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
        inherit (config.meta.build) url hash;
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
        build = sources.paper.builds."${config.minecraftVersion}";
        mainClass = "io.papermc.paperclip.Paperclip";
      };
      defaultText = ''meta'';
    };
  };
}
