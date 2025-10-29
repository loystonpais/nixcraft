{
  lib,
  sources,
  pkgs,
  parseForgeInstaller,
  fetchSha1,
  ...
}: {
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

    _instanceType = lib.mkOption {
      type = lib.types.enum ["client" "server"];
      internal = true;
    };

    parsedForgeLoader = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      default = parseForgeInstaller {
        jar = pkgs.fetchurl {
          url = "https://maven.minecraftforge.net/net/minecraftforge/forge/${config.minecraftVersion}-${config.version}/forge-${config.minecraftVersion}-${config.version}-installer.jar";
          hash = config.hash;
        };
      };
      defaultText = ''parsedForgeLoader'';
    };

    hash = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = lib.fakeHash;
    };
  };
}
