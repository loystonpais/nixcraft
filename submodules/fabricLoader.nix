{
  lib,
  pkgs,
  fetchFabricLoaderImpure,
  sources,
  ...
}: {config, ...}: {
  options = {
    enable = lib.mkEnableOption "fabric loader";

    version =
      lib.nixcraft.options.fabricLoaderVersionDyn
      // {
        default = "latest";
        defaultText = "latest";
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
      defaultText = ''meta'';
      default =
        {
          clientMainClass = "net.fabricmc.loader.impl.launch.knot.KnotClient";
          serverMainClass = "net.fabricmc.loader.impl.launch.knot.KnotServer";
        }
        // {
          lock = sources.fabric.loaders.${config.version};
          mappings = sources.fabric.mappings.${config.minecraftVersion};
        };
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
