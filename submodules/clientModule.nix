{
  lib,
  clientInstanceModule,
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
