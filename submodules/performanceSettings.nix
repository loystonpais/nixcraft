{lib, ...}: {
  name,
  config,
  ...
}: {
  options = {
    enableFeralGameMode = lib.mkOption {
      type = lib.types.bool;
    };

    enableMangoHud = lib.mkOption {
      type = lib.types.bool;
    };

    useDiscreteGPU = lib.mkOption {
      type = lib.types.bool;
    };

    useZink = lib.mkOption {
      type = lib.types.bool;
    };
  };
}
