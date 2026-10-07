{
  lib,
  sources,
  ...
}: {config, ...}: {
  options = {
    enable = lib.mkEnableOption "quilt loader";

    version = lib.mkOption {
      type = lib.types.nonEmptyStr;
    };

    minecraftVersion = lib.nixcraft.options.minecraftVersionDyn;

    hash = lib.mkOption {
      type = lib.types.nonEmptyStr;
    };

    _instanceType = lib.mkOption {
      type = lib.types.enum ["client" "server"];
      internal = true;
    };

    finalLibraries = lib.mkOption {
      type = lib.types.attrsOf lib.nixcraft.types.library;
      readOnly = true;
    };

    meta = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      default = {
        lock = sources.quilt.lock.${config.version};
        gameLock = sources.quilt.game-lock.${config.minecraftVersion};
      };
      defaultText = ''meta'';
    };
  };

  config = {
    hash = lib.mkOptionDefault lib.fakeHash;

    finalLibraries = let
      inherit (lib.nixcraft.maven) mkLibUrl mkLibPath;
      inherit (sources) maven-libraries;
      dependencies =
        config.meta.lock.dependencies.common
        ++ config.meta.lock.dependencies.${config._instanceType}
        ++ config.meta.gameLock.dependencies ++ [config.meta.lock.name];
    in
      lib.listToAttrs (map (library:
        lib.nameValuePair library {
          enable = true;
          native = false;
          relativePath = mkLibPath library;
          jar = builtins.fetchurl {
            url = mkLibUrl maven-libraries.${library}.url library;
            sha256 = maven-libraries.${library}.sha256;
          };
        })
      dependencies);
  };
}
