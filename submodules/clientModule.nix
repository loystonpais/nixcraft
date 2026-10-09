{
  lib,
  clientInstanceModule,
  ...
}: {
  config,
  dir,
  authDirPrefix,
  externalAssetsDirPrefix,
  skinsDirPrefix,
  externalAssetsLookupPaths,
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
            readOnlyName = true;
            inherit
              authDirPrefix
              externalAssetsDirPrefix
              skinsDirPrefix
              externalAssetsLookupPaths
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
