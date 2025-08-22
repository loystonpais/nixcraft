{
  lib,
  clientModule,
  ...
}: {
  name,
  config,
  ...
}: {
  options = {
    enable = lib.mkEnableOption name;

    client = lib.mkOption {
      type = lib.types.submodule clientModule;
    };
  };
}
