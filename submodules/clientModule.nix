{
  lib,
  clientInstanceModule,
  minecraftAccountModule,
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
          modules = [clientInstanceModule];
          specialArgs = {
            shared = config.shared;
            dirPrefix = "${config.dir}";
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
