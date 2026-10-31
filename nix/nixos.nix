{
  config,
  ...
} @ top: {
  flake.nixosModules.default = {
    pkgs,
    config,
    lib,
    ...
  }: let
    nixcraftModule = top.config.nixcraft.module;
    clientAuthPkg = top.config.nixcraft.lib.clientAuth.mkPackage pkgs;
    clientFetchAssetsPkg = top.config.nixcraft.lib.clientFetchAssets.mkPackage pkgs;

    perServerInstance = cfgF:
      lib.mkMerge (lib.mapAttrsToList (_: cfgF) config.nixcraft.server.instances);
  in {
    options = {
      nixcraft = lib.mkOption {
        type = lib.types.submoduleWith {
          modules = [
            nixcraftModule
            ({lib, ...}: {
              options.cache = {
                enable =
                  (lib.mkEnableOption "nixcraft cache")
                  // {
                    default = true;
                  };

                path = lib.mkOption {
                  type = lib.types.str;
                  default = "/var/cache/nixcraft";
                  description = "Path to nixcraft cache directory";
                };
              };

              options.renice = {
                enable =
                  (lib.mkEnableOption "renice wrapper with CAP_SYS_NICE capability")
                  // {
                    default = false;
                    description = "Wrap renice binary with cap_sys_nice capability under /run/wrappers/bin/nixcraft-renice so it can be run without sudo.";
                  };
              };
            })
          ];
          specialArgs = {
            clientDirPrefix = "/var/lib/nixcraft/client/instances";
            clientAuthDirPrefix = "/var/lib/nixcraft/client/auth";
            serverDirPrefix = "/var/lib/nixcraft/server/instances";
            clientExternalAssetsDirPrefix = "/var/lib/nixcraft/client/assets";
            clientSkinsDirPrefix = "/var/lib/nixcraft/client/skins";
            clientExternalAssetsLookupPaths = [
              "/var/cache/nixcraft/asset-objects"
            ];
            inherit pkgs;
            moduleType = "nixos";
          };
        };
      };
    };

    config = lib.mkMerge [
      {
        nixcraft = {
          client = {};
          server = {};
        };
      }

      (lib.mkIf config.nixcraft.enable (
        lib.mkMerge [
          # Generic
          {
            environment.systemPackages = [
              clientAuthPkg
              clientFetchAssetsPkg
            ];

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

          # Cache setup
          (lib.mkIf config.nixcraft.cache.enable {
            nix.settings.extra-sandbox-paths = [
              config.nixcraft.cache.path
            ];

            systemd.tmpfiles.rules = [
              "d ${config.nixcraft.cache.path}/asset-objects 0775 nixcraft nixcraft - -"
            ];
          })

          # Renice wrapper
          (lib.mkIf config.nixcraft.renice.enable {
            security.wrappers.nixcraft-renice = {
              source = "${pkgs.util-linux}/bin/renice";
              capabilities = "cap_sys_nice+ep";
              owner = "root";
              group = "root";
              permissions = "u+rx,g+rx,o+rx";
            };
          })

          # Managing server
          {
            systemd.services = perServerInstance (instance:
              lib.mkIf instance.service.enable {
                "nixcraft-server-${instance.name}" = {
                  description = "nixcraft server instance ${instance.name}";
                  wantedBy = lib.optional instance.service.autoStart "multi-user.target";
                  after = ["network.target"];
                  serviceConfig = {
                    Restart = "always";
                    User = "nixcraft";
                    Group = "nixcraft";
                    WorkingDirectory = instance.absoluteDir;
                    ExecStart = lib.getExe instance.binEntry.finalBin;
                  };
                };
              });

            system.activationScripts.nixcraftActivation = {
              text = ''
                # Nixcraft activation script
                ${config.nixcraft.finalActivationShellScript}
              '';
              deps = [];
            };

            networking.firewall = lib.mkMerge [
              (perServerInstance (instance: {
                allowedTCPPorts = lib.optional (instance.openFirewall && (instance.serverProperties != null) && (instance.serverProperties ? "server-port")) instance.serverProperties.server-port;
                allowedUDPPorts = lib.optional (instance.openFirewall && (instance.serverProperties != null) && (instance.serverProperties ? "server-port")) instance.serverProperties.server-port;
              }))
            ];
          }
        ]
      ))
    ];
  };
}
