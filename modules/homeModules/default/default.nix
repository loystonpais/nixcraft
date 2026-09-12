{
  lib,
  localFlake,
  sources,
  ...
} @ flakeModuleArgs: {
  pkgs,
  config,
  ...
} @ hmModuleArgs: let
  passThroughArgs =
    flakeModuleArgs
    // {
      inherit pkgs;
      inherit (pkgs) system;
    }
    // builders;

  submodules = lib.nixcraft.importSubmodules "${localFlake}/submodules" passThroughArgs;
  builders = lib.nixcraft.importBuilders "${localFlake}/builders" passThroughArgs;
  scripts = lib.nixcraft.importScripts "${localFlake}/scripts" pkgs;

  inherit (submodules) nixcraftModule;

  perClientInstance = cfgF:
    lib.mkMerge (lib.mapAttrsToList (_: instance: cfgF instance) config.nixcraft.client.instances);

  perServerInstance = cfgF:
    lib.mkMerge (lib.mapAttrsToList (_: instance: cfgF instance) config.nixcraft.server.instances);

  # placing files set to dirFiles using home.file
  placeFilesFromDirFiles = dirFiles: instanceDirInHome: {
    file =
      lib.mapAttrs' (fileName: fileAttr: let
        placePath = fileAttr.target;
      in {
        name = builtins.unsafeDiscardStringContext "${instanceDirInHome}/${placePath}";
        value =
          {
            enable = fileAttr.enable;
            source = fileAttr.source;
          }
          // fileAttr.extraConfig;
      })
      dirFiles;
  };
in {
  options = {
    nixcraft = lib.mkOption {
      type = lib.types.submoduleWith {
        modules = [nixcraftModule];
        specialArgs = {
          clientDirPrefix = "${config.home.homeDirectory}/.local/share/nixcraft/client/instances";
          clientAuthDirPrefix = "${config.home.homeDirectory}/.local/share/nixcraft/client/auth";
          serverDirPrefix = "${config.home.homeDirectory}/.local/share/nixcraft/server/instances";
          clientExternalAssetDirPrefix = "${config.home.homeDirectory}/.local/share/nixcraft/client/assets";
          clientExternalAssetLookupPaths = [
            "${config.home.homeDirectory}/.local/share/PrismLauncher/assets"
            "${config.home.homeDirectory}/.minecraft/assets"
            "/var/cache/nixcraft/asset-objects"
          ];
        };
      };
    };
  };

  config = lib.mkMerge [
    {
      nixcraft = {
        client = {
        };
        server = {
        };
      };
    }

    (lib.mkIf config.nixcraft.enable (
      lib.mkMerge [
        # Generic
        {
          home.activation.nixcraftActivation = hmModuleArgs.lib.hm.dag.entryAfter ["writeBoundary"] (config.nixcraft.finalActivationShellScript);
          home.packages = [
            scripts.client-auth
            scripts.client-fetch-assets
          ];
        }

        # Managing client
        {
          home = lib.mkMerge [
            (lib.mkIf (config.nixcraft.client.auth.uuid != null) {
              sessionVariables = {
                NIXCRAFT_CLIENT_AUTH_UUID = config.nixcraft.client.auth.uuid;
              };
            })

            (perClientInstance (
              instance:
                lib.mkIf instance.enable (lib.mkMerge [
                  (lib.mkIf instance.binEntry.enable {
                    packages = [instance.binEntry.finalBin];
                  })

                  (placeFilesFromDirFiles (lib.filterAttrs (name: file: file.method == "default") instance.files)
                    instance.dir)
                ])
            ))
          ];

          # Place desktop entries
          xdg = perClientInstance (instance: let
            entryName = "nixcraft-${instance.name}";
          in
            lib.mkIf (instance.enable && instance.desktopEntry.enable) (
              lib.mkMerge [
                {
                  desktopEntries.${entryName} =
                    {
                      exec = lib.mkDefault "${lib.getExe instance.binEntry.finalBin}";
                      name = lib.mkDefault instance.desktopEntry.name;
                    }
                    // instance.desktopEntry.extraConfig;
                }
              ]
            ));
        }

        # Managing server
        {
          home = perServerInstance (
            instance:
              lib.mkIf instance.enable (lib.mkMerge [
                (lib.mkIf instance.binEntry.enable {
                  packages = [instance.binEntry.finalBin];
                })

                (placeFilesFromDirFiles (lib.filterAttrs (name: file: file.method == "default") instance.files)
                  instance.dir)
              ])
          );

          # setting systemd user services
          systemd = perServerInstance (
            instance: let
              serviceName = "nixcraft-server-${instance.name}";
            in
              lib.mkMerge [
                (lib.mkIf (instance.enable && instance.service.enable) {
                  user.services.${serviceName} = {
                    Unit = {
                      Description = "Minecraft Server ${instance.name}";
                      After = ["network.target"];
                      Wants = ["network.target"];
                    };
                    Service = {
                      ExecStart = "${lib.getExe instance.binEntry.finalBin}";
                      Restart = "on-failure";
                    };
                    Install = lib.mkIf instance.service.autoStart {
                      WantedBy = ["default.target"];
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
