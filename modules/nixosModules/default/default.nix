{
  lib,
  localFlake,
  sources,
  ...
} @ flakeModuleArgs: {
  pkgs,
  config,
  ...
}: let
  passThroughArgs =
    flakeModuleArgs
    // {
      inherit pkgs;
      inherit (pkgs) system;
    }
    // builders;

  submodules = lib.nixcraft.importSubmodules "${localFlake}/submodules" passThroughArgs;
  builders = lib.nixcraft.importBuilders "${localFlake}/builders" passThroughArgs;

  inherit (submodules) nixcraftModule;

  perClientInstance = cfgF:
    lib.mkMerge (lib.mapAttrsToList (_: instance: cfgF instance) config.nixcraft.client.instances);

  perServerInstance = cfgF:
    lib.mkMerge (lib.mapAttrsToList (_: instance: cfgF instance) config.nixcraft.server.instances);
in {
  options = {
    nixcraft = lib.mkOption {
      type = lib.types.submodule nixcraftModule;
    };
  };

  config = lib.mkMerge [
    {
      nixcraft = {
        client = {
          dirPrefix = "client/instances";
          rootDir = "/var/lib/nixcraft";
        };
        server = {
          dirPrefix = "server/instances";
          rootDir = "/var/lib/nixcraft";
        };
      };
    }

    (lib.mkIf config.nixcraft.enable (
      lib.mkMerge [
        # Generic
        {
          users = {
            users.nixcraft = {
              description = "Nixcraft user";
              home = "/var/lib/nixcraft";
              isSystemUser = true;
              createHome = true;
              group = "nixcraft";
            };

            groups.nixcraft = {};
          };
        }

        # Managing server
        {
          environment = perServerInstance (
            instance:
              lib.mkIf instance.enable (lib.mkMerge [
                (lib.mkIf instance.binEntry.enable {
                  systemPackages = [instance.binEntry.finalBin];
                })
              ])
          );

          # setting systemd services
          systemd = perServerInstance (
            instance: let
              serviceName = "nixcraft-server-${instance.name}";
            in
              lib.mkMerge [
                (lib.mkIf instance.enable {
                  services.${serviceName} = {
                    enable = instance.service.enable;
                    description = "Minecraft Server ${instance.name}";
                    wantedBy = lib.mkIf instance.service.autoStart ["multi-user.target"];
                    after = ["network.target"];
                    serviceConfig = {
                      User = "nixcraft";
                      Group = "nixcraft";
                      WorkingDirectory = "/var/lib/nixcraft";
                      ExecStart = "${lib.getExe instance.binEntry.finalBin}";
                      Restart = "on-failure";
                    };
                  };
                })
              ]
          );
        }
      ]
    ))
  ];
}
