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

  # TODO: generalize this / reduce code duplication
  # placing files set to dirFiles using home.file
  placeFilesFromDirFiles = dirFiles: instanceDirInHome: {
    file = lib.mapAttrs' (fileName: fileAttr: let
      # NOTE: Some files need to be mutable. Unfortunately, home manager does not provide
      # a clean way to do that.
      # The strategy is to place the alternate path using home.file and then use its
      # onChange directive to place the actual file as a rewritable copy
      placePath = fileAttr.target;

      # Get the dir and the file name so that we can place a renamed version of the file
      placePathDir = builtins.dirOf placePath;
      placePathFile = builtins.baseNameOf placePath;

      placePathAlt = "${placePathDir}/.hm-placed.${placePathFile}";

      # Create version of each path with home prefix
      placePath'home = "${config.home.homeDirectory}/${instanceDirInHome}/${placePath}";
      placePathAlt'home = "${config.home.homeDirectory}/${instanceDirInHome}/${placePathAlt}";
    in
      if fileAttr.mutable
      then {
        name = builtins.unsafeDiscardStringContext "${instanceDirInHome}/${placePathAlt}";
        value = {
          enable = fileAttr.enable;
          source = fileAttr.source;
          onChange = ''
            if [ ! -f "${placePath'home}" ]; then
              # rm -f "${placePath'home}"
              cp "${placePathAlt'home}" "${placePath'home}"
              chmod u+w "${placePath'home}"
            fi
          '';
        };
      }
      else {
        name = builtins.unsafeDiscardStringContext "${instanceDirInHome}/${placePath}";
        value = {
          enable = fileAttr.enable;
          source = fileAttr.source;
        };
      })
    dirFiles;
  };
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
          instanceDirPrefix = ".local/share/nixcraft/client/instances";
          rootDir = config.home.homeDirectory;
        };
        server = {
          instanceDirPrefix = ".local/share/nixcraft/server/instances";
          rootDir = config.home.homeDirectory;
        };
      };
    }

    (lib.mkIf config.nixcraft.enable (
      lib.mkMerge [
        # Managing client
        {
          home = perClientInstance (
            instance:
              lib.mkIf instance.enable (lib.mkMerge [
                # Place run file at instances/<name>/run which can be executed
                {
                  file."${instance.dir}/run" = {
                    executable = true;
                    text = instance.finalLaunchShellScript;
                  };
                }

                (lib.mkIf instance.binEntry.enable {
                  packages = [instance.binEntry.finalBin];
                })

                (placeFilesFromDirFiles instance.dirFiles instance.dir)
              ])
          );

          # Place desktop entries
          xdg = perClientInstance (instance: let
            entryName = "nixcraft-${instance.name}";
          in
            lib.mkIf (instance.enable && instance.desktopEntry.enable) (
              lib.mkMerge [
                {
                  desktopEntries.${entryName} =
                    {
                      exec = lib.mkDefault "${instance.absoluteDir}/run";
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
                # Place run file at instances/<name>/run which can be executed
                {
                  file."${instance.dir}/run" = {
                    executable = true;
                    text = instance.finalLaunchShellScript;
                  };
                }

                (lib.mkIf instance.binEntry.enable {
                  packages = [instance.binEntry.finalBin];
                })

                (placeFilesFromDirFiles instance.dirFiles instance.dir)
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
                      ExecStart = "${pkgs.writeTextFile
                        {
                          name = "run";
                          text = instance.finalLaunchShellScript;
                          executable = true;
                        }}";
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
