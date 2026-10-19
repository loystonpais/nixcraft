{
  lib,
  pkgs,
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
        lock = sources.quilt.loaders.${config.version};
        mappings = sources.quilt.mappings.${config.minecraftVersion};
      };
      defaultText = ''meta'';
    };
  };

  config = {
    hash = lib.mkOptionDefault lib.fakeHash;

    finalLibraries = let
      inherit (lib.nixcraft.maven) mkLibPath;
      dependencies =
        config.meta.lock.dependencies.common
        ++ config.meta.lock.dependencies.${config._instanceType}
        ++ (config.meta.mappings or [])
        ++ [config.meta.lock.name];
    in
      lib.listToAttrs (map (library:
        lib.nameValuePair library {
          enable = true;
          native = false;
          relativePath = mkLibPath library;
          jar = pkgs.fetchurl {
            inherit (sources.libraries.${library}) url hash;
          };
        })
      dependencies);
  };
}
