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
            dirPrefix = "${config.rootDir}/${config.dirPrefix}";
          };
        });
    };

    shared = lib.mkOption {
      type = with lib.types; attrs;
      default = {};
    };

    dirPrefix = lib.mkOption {
      type = lib.types.pathWith {absolute = false;};
      internal = true;
    };

    rootDir = lib.mkOption {
      type = lib.types.pathWith {absolute = true;};
      readOnly = true;
      internal = true;
    };
  };
}
