{
  lib,
  clientInstanceModule,
  minecraftAccountModule,
  ...
}: {
  config,
  dir,
  authDirPrefix,
  externalAssetDirPrefix,
  externalAssetLookupPaths,
  ...
}: {
  options = {
    auth = {
      uuid = lib.mkOption {
        type = with lib.types; nullOr nonEmptyStr;
        default = null;
        description = "Default player UUID for client authentication.";
      };
    };

    instances = lib.mkOption {
      type = with lib.types;
        attrsOf (submoduleWith {
          modules = [clientInstanceModule];
          specialArgs = {
            shared = config.shared;
            dirPrefix = "${config.dir}";
            inherit
              authDirPrefix
              externalAssetDirPrefix
              externalAssetLookupPaths
              ;
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
