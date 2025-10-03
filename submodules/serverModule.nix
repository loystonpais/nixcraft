{
  lib,
  serverInstanceModule,
  ...
}: {
  config,
  dir,
  ...
}: {
  options = {
    instances = lib.mkOption {
      type = with lib.types;
        attrsOf (submoduleWith {
          modules = [serverInstanceModule];
          specialArgs = {
            shared = config.shared;
            dirPrefix = config.dir;
            # name = "<name>";
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
