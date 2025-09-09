{
  lib,
  clientModule,
  serverModule,
  ...
}: {
  name,
  config,
  ...
}: let
  perClientInstance = cfgF:
    lib.mkMerge (lib.mapAttrsToList (_: instance: cfgF instance) config.client.instances);

  perServerInstance = cfgF:
    lib.mkMerge (lib.mapAttrsToList (_: instance: cfgF instance) config.server.instances);
in {
  options = {
    enable = lib.mkEnableOption name;

    client = lib.mkOption {
      type = lib.types.submodule clientModule;
    };

    server = lib.mkOption {
      type = lib.types.submodule serverModule;
    };

    finalActivationShellScript = lib.mkOption {
      readOnly = true;
      type = lib.types.str;
    };
  };

  config = lib.mkMerge [
    {
      finalActivationShellScript = lib.concatStringsSep "\n" [
        (lib.concatMapAttrsStringSep "\n" (name: instance: instance.finalActivationShellScript) config.client.instances)
        (lib.concatMapAttrsStringSep "\n" (name: instance: instance.finalActivationShellScript) config.server.instances)
      ];
    }
  ];
}
