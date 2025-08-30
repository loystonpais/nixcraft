{
  lib,
  clientInstanceModule,
  minecraftAccountModule,
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
          modules = [clientInstanceModule];
          specialArgs = {
            shared = config.shared;
            instanceDirPrefix = config.instanceDirPrefix;
            rootDir = config.rootDir;
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

    instanceDirPrefix = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      internal = true;
    };

    rootDir = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      internal = true;
    };
  };
}
