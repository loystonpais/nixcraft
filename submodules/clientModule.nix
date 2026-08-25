{
  lib,
  clientInstanceModule,
  minecraftAccountModule,
  ...
}: {
  config,
  dir,
  externalAssetDirPrefix,
  externalAssetLookupPaths,
  ...
}: {
  options = {
    instances = lib.mkOption {
      type = with lib.types;
        attrsOf (submoduleWith {
          modules = [clientInstanceModule];
          specialArgs = {
            shared = config.shared;
            dirPrefix = "${config.dir}";
            externalAssetDirPrefix = externalAssetDirPrefix;
            externalAssetLookupPaths = externalAssetLookupPaths;
          };
        });
    };

    accounts = lib.mkOption {
      type = with lib.types; attrsOf (submodule minecraftAccountModule);
      default = {};
    };

    shared = lib.mkOption {
      type = with lib.types; attrs;
      default = {};
    };

    dir = lib.mkOption {
      type = lib.types.pathWith {absolute = true;};
      default = dir;
    };
  };
}
