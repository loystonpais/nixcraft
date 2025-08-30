{
  lib,
  serverInstanceModule,
  ...
}: {
  name,
  config,
  ...
}: {
  options = {
    instances = lib.mkOption {
      type = with lib.types;
        attrsOf (submoduleWith {
          modules = [serverInstanceModule];
          specialArgs = {
            shared = config.shared;
            instanceDirPrefix = config.instanceDirPrefix;
            rootDir = config.rootDir;
          };
        });
    };

    shared = lib.mkOption {
      type = with lib.types; attrs;
      default = {};
    };

    instanceDirPrefix = lib.mkOption {
      type = lib.types.nonEmptyStr;
      internal = true;
    };

    rootDir = lib.mkOption {
      type = lib.types.nonEmptyStr;
      readOnly = true;
      internal = true;
    };
  };
}
