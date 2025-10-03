{
  lib,
  clientModule,
  serverModule,
  ...
}: {
  name,
  config,
  clientDirPrefix,
  serverDirPrefix,
  ...
}: {
  options = {
    enable = lib.mkEnableOption name;

    client = lib.mkOption {
      type = lib.types.submoduleWith {
        modules = [clientModule];
        specialArgs = {
          dir = clientDirPrefix;
        };
      };
    };

    server = lib.mkOption {
      type = lib.types.submoduleWith {
        modules = [serverModule];
        specialArgs = {
          dir = serverDirPrefix;
        };
      };
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
