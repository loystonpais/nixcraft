{
  lib,
  fetchFabricLoaderImpure,
  sources,
  ...
}: {config, ...}: let
  loaderVersions = lib.attrNames sources.fabric.lock;
  latestLoaderVersion = lib.foldl' (
    latest: version:
      if builtins.compareVersions version latest > 0
      then version
      else latest
  ) (builtins.head loaderVersions) (builtins.tail loaderVersions);
in {
  options = {
    enable = lib.mkEnableOption "fabric loader";

    version = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = latestLoaderVersion;
      defaultText = lib.literalExpression ''latest Fabric Loader version in sources/fabric/lock.json'';
      description = ''
        Fabric Loader version. Defaults to the latest version available in the
        repository's Fabric lock file.
      '';
    };

    minecraftVersion = lib.nixcraft.options.minecraftVersionDyn;

    hash = lib.mkOption {
      type = lib.types.nonEmptyStr;
    };

    _instanceType = lib.mkOption {
      type = lib.types.enum ["client" "server"];
      internal = true;
    };

    _impurePackage = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      defaultText = ''package'';
      default = fetchFabricLoaderImpure {
        mcVersion = config.minecraftVersion;
        loaderVersion = config.version;
        client = config._instanceType == "client";
        server = config._instanceType == "server";
        hash = config.hash;
      };
    };

    classes = lib.mkOption {
      type = lib.types.listOf lib.types.path;
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
          lock = sources.fabric.lock.${config.version};
          gameLock = sources.fabric.game-lock.${config.minecraftVersion};
        };
    };
  };

  config = {
    hash = lib.mkOptionDefault lib.fakeHash;

    classes = let
      inherit (lib.nixcraft.maven) mkLibUrl;
      inherit (sources) maven-libraries;
      dependencies =
        config.meta.lock.dependencies.common
        ++ config.meta.lock.dependencies.${config._instanceType}
        ++ config.meta.gameLock.dependencies ++ [config.meta.lock.name];
    in
      map (library:
        builtins.fetchurl {
          url = mkLibUrl maven-libraries.${library}.url library;
          sha256 = maven-libraries.${library}.sha256;
        })
      dependencies;
  };
}
