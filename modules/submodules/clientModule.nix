{
  lib,
  clientInstanceModule,
  ...
}: {
  name,
  config,
  ...
}: {
  options = {
    instances = lib.mkOption {
      type = with lib.types; attrsOf (submodule clientInstanceModule);
    };
  };
}
