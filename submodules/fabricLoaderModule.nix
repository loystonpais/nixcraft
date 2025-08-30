{
  lib,
  fetchFabricLoaderImpure,
  ...
}: {
  name,
  config,
  ...
}: {
  options = {
    enable = lib.mkEnableOption "fabric loader";

    version = lib.mkOption {
      type = lib.types.str;
    };

    minecraftVersion = lib.nixcraft.options.minecraftVersionDyn;

    hash = lib.mkOption {
      type = lib.types.str;
    };

    _instanceType = lib.mkOption {
      type = lib.types.enum ["client" "server"];
    };

    _impurePackage = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = fetchFabricLoaderImpure {
        mcVersion = config.minecraftVersion;
        loaderVersion = config.version;
        client = config._instanceType == "client";
        server = config._instanceType == "server";
        hash = config.hash;
      };
    };

    meta = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      default = {
        clientMainClass = "net.fabricmc.loader.impl.launch.knot.KnotClient";
        serverMainClass = "net.fabricmc.loader.impl.launch.knot.KnotServer";
      };
    };
  };

  config = {
    hash = lib.mkOptionDefault lib.fakeHash;
  };
}
