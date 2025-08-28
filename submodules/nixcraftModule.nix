{
  lib,
  clientModule,
  serverModule,
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

    server = lib.mkOption {
      type = lib.types.submodule serverModule;
    };
  };
}
