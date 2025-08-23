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
        attrsOf (submodule clientInstanceModule);
    };

    accounts = lib.mkOption {
      type = with lib.types; attrsOf (submodule minecraftAccountModule);
      default = {};
    };
  };
}
