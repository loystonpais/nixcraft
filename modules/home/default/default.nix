{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the module system.
  config,
  ...
} @ args: let
  args' =
    args
    // {
      inherit sources;
    }
    // builders;

  inherit (lib.nixcraft.importSubmodules ../../submodules args') nixcraftModule;

  builders = lib.nixcraft.importBuilders ../../../builders args';
  sources = lib.nixcraft.importSources ../../../sources;

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
    (lib.mkIf config.nixcraft.enable (
      lib.mkMerge [
        # Managing client
        {
          home = perClientInstance (instance: let
            instanceDirInHome = ".local/share/nixcraft/client/instances/${instance.name}";
            absoluteDirPath = "${config.home.homeDirectory}/${instanceDirInHome}";
          in
            lib.mkMerge [
              # Place run file at instances/<name>/run which can be executed
              {
                file."${instanceDirInHome}/run" = {
                  executable = true;
                  text = ''
                    #!${pkgs.bash}/bin/bash

                    ${lib.nixcraft.mkExportedEnvVars instance.envVars}

                    cd "${absoluteDirPath}"

                    exec ${instance.launchShellCommandString} "$@"
                  '';
                };
              }

              # If waywall is enabled, place waywall-run at instances/<name>/waywall-run
              # which can be executed
              (lib.mkIf instance.waywall.enable {
                file."${instanceDirInHome}/waywall-run" = {
                  executable = true;
                  text = ''
                    #!${pkgs.bash}/bin/bash

                    exec "${pkgs.waywall}/bin/waywall" wrap -- "${absoluteDirPath}/run" "$@"
                  '';
                };
              })

              (placeFilesFromDirFiles instance.dirFiles instanceDirInHome)
            ]);
        }

        # Managing server
        {
          home = perServerInstance (instance: let
            instanceDirInHome = ".local/share/nixcraft/server/instances/${instance.name}";
            absoluteDirPath = "${config.home.homeDirectory}/${instanceDirInHome}";
          in
            lib.mkMerge [
              # Place run file at instances/<name>/run which can be executed
              {
                file."${instanceDirInHome}/run" = {
                  executable = true;
                  text = ''
                    #!${pkgs.bash}/bin/bash

                    ${lib.nixcraft.mkExportedEnvVars instance.envVars}

                    cd "${absoluteDirPath}"

                    exec ${instance.launchShellCommandString} "$@"
                  '';
                };
              }

              (placeFilesFromDirFiles instance.dirFiles instanceDirInHome)
            ]);

          # setting systemd user services
          systemd = perServerInstance (
            instance: let
              serviceName = "nixcraft-server-${instance.name}";
              instanceDirInHome = ".local/share/nixcraft/server/instances/${instance.name}";
              absoluteDirPath = "${config.home.homeDirectory}/${instanceDirInHome}";
              runScriptAbsolutePath = "${absoluteDirPath}/run";
            in
              lib.mkMerge [
                (lib.mkIf instance.service.enable {
                  user.services.${serviceName} = {
                    Unit = {
                      Description = "Minecraft Server ${instance.name}";
                      After = ["network.target"];
                      Wants = ["network.target"];
                    };
                    Service = {
                      ExecStart = "${runScriptAbsolutePath}";
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
