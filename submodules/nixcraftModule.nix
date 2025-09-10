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

    activationShellScript = lib.mkOption {
      type = lib.types.lines;
    };

    finalActivationShellScript = lib.mkOption {
      readOnly = true;
      type = lib.types.lines;
    };
  };

  config = lib.mkMerge [
    {
      finalActivationShellScript = ''
        ${config.activationShellScript}
      '';
    }

    {
      activationShellScript = lib.concatMapAttrsStringSep "\n" (name: instance: instance.finalActivationShellScript) config.client.instances;
    }

    {
      activationShellScript = lib.concatMapAttrsStringSep "\n" (name: instance: instance.finalActivationShellScript) config.server.instances;
    }
  ];
}
