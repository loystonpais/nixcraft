# Nixcraft (WIP)

Example home manager configuration (might break)

```nix
# This config showcases several nixcraft's features (home manager only)
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  # Fetch any mrpack which can be used with both servers and clients!
  simply-optimized-mrpack = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/BYfVnHa7/versions/vZZwrcPm/Simply%20Optimized-1.21.1-5.0.mrpack";
    hash = "sha256-n2BxHMmqpOEMsvDqRRYFfamcDCCT4ophUw7QAJQqXmg=";
  };
in {
  imports = [
    # Import the nixcraft home module
    inputs.nixcraft.homeModules.default
  ];

  config = {
    nixcraft = {
      /*
      * Options starting with underscore such as _clientSettings are for advanced use case
      * Most instance options (such as java, mod loaders) are generic. There are also client/server specific options
      * Options are mostly inferred to avoid duplication.
        Ex: minecraft versions and mod loader versions are automatically inferred if mrpack is set

      * Instances are placed under ~/.local/share/nixcraft/client/instances/<name> or ~/.local/share/nixcraft/server/instances/<name>

      * Executable to run the instance will be put in path as nixcraft-<server/client>-<name>
      * Ex: nixcraft-client-myclient
      * See the binEntry option for customization

      * Read files found under submodules for more options
      * Read submodules/genericInstanceModule.nix for generic options
      */

      enable = true;

      server = {
        # Config shared with all instances
        shared = {
          agreeToEula = true;
          serverProperties.online-mode = false;

          binEntry.enable = true;
        };

        instances = {
          # Example server with bare fabric loader
          smp = {
            enable = true;
            version = "1.21.1";
            fabricLoader = {
              enable = true;
              version = "0.17.2";
              hash = "sha256-hCQBYgdxfBqskQ100Ae0xfCbAZB2xkCxdKyImpkiB4U=";
            };
          };

          # Example server with simply-optimized mrpack loaded
          simop = {
            enable = true;
            mrpack = {
              enable = true;
              file = simply-optimized-mrpack;
            };
            java.memory = 2000;
            fabricLoader.hash = "sha256-2UAt7yP28tIQb6OTizbREVnoeu4aD8U1jpy7DSKUyVg";
            serverProperties = {
              level-seed = "6969";
              online-mode = false;
              bug-report-link = null;
            };
            # servers can be run as systemd user services
            # service name is set as nixcraft-server-<name>.service
            service = {
              enable = true;
              autoStart = false;
            };
          };

          # Example paper server
          paper-server = {
            version = "1.21.1";
            enable = true;
            paper.enable = true;
            java.memory = 2000;
            serverProperties.online-mode = false;
          };

          onepoint5 = {
            enable = true;
            version = "1.5.1";
          };

          onepoint8 = {
            enable = true;
            version = "1.8";
          };

          onepoint12 = {
            version = "1.12.1";
            enable = true;
            agreeToEula = true;
            # Old versions fail to start if server poperties is immutable
            # So copy the file instead
            files."server.properties".method = lib.mkForce "copy";
            binEntry.enable = true;
          };
        };
      };

      client = {
        # Config to share with all instances
        shared = {
          # Symlink screenshots dir from all instances
          files."screenshots".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Pictures";

          # Common account
          account = {
            username = "loystonlive";
            uuid = "2909ee95-d459-40c4-bcbb-65a0cc413110";
            offline = true;
          };

          # Game is passed to the gpu (set if you have nvidia gpu)
          enableNvidiaOffload = true;

          envVars = {
            # Fixes bug with nvidia
            __GL_THREADED_OPTIMIZATIONS = "0";
          };

          binEntry.enable = true;
        };

        instances = {
          # Example instance with simply-optimized mrpack
          simop = {
            enable = true;

            # Add a desktop entry
            desktopEntry = {
              enable = true;
            };
            mrpack = {
              enable = true;
              file = simply-optimized-mrpack;
            };
            fabricLoader.hash = "sha256-2UAt7yP28tIQb6OTizbREVnoeu4aD8U1jpy7DSKUyVg=";
          };

          # Example bare bones client
          nomods = {
            enable = true;
            version = "1.21.1";
          };

          # Example client whose version is "latest-release"
          # Supports "latest-snapshot" too
          latest = {
            enable = true;
            version = "latest-release";
          };

          # Audio doesn't seem to work in old versions
          onepoint5 = {
            enable = true;
            version = "1.5.1";
          };

          onepoint8 = {
            enable = true;
            version = "1.8";
          };

          onepoint12 = {
            enable = true;
            version = "1.12.1";
          };

          # Example client customized for minecraft speedrunning
          fsg = {
            enable = true;

            # this advanced option accepts common arguments that are passed to the client
            _classSettings = {
              fullscreen = true;
              # height = 1080;
              # width = 1920;
              uuid = "2909ee95-d459-40c4-bcbb-65a0cc413110";
              username = "loystonlive";
            };
            # version = "1.16.1"; # need not be set (inferred)

            mrpack = {
              enable = true;
              file = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/1uJaMUOm/versions/jIrVgBRv/SpeedrunPack-mc1.16.1-v5.3.0.mrpack";
                hash = "sha256-uH/fGFrqP2UpyCupyGjzFB87LRldkPkcab3MzjucyPQ=";
              };
            };

            fabricLoader.hash = "sha256-go+Y7m4gD+4ALBuYxKhM9u8Oo/T8n5LAYO3QWAMfnMQ=";

            # place custom files
            files = {
              # mods can also be manually set
              "mods/fsg-mod.jar".source = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/XZOGBIpM/versions/TcTlTNlF/fsg-mod-5.1.0%2BMC1.16.1.jar";
                hash = "sha256-gQfbJMsp+QEnuz4T7dC1jEVoGRa5dmK4fXO/Ea/iM+A=";
              };

              # setting config files
              "config/mcsr/standardsettings.json".source = ./standardsettings.json;
              "options.txt" = {
                source = ./options.txt;
              };
            };

            java = {
              extraArguments = [
                "-XX:+UseZGC"
                "-XX:+AlwaysPreTouch"
                "-Dgraal.TuneInlinerExploration=1"
                "-XX:NmethodSweepActivity=1"
              ];
              # override java package. This mrpack needs java 17
              package = pkgs.jdk17;
              # set memory in MBs
              maxMemory = 3500;
              minMemory = 3500;
            };

            # waywall can be enabled
            waywall.enable = true;

            # Add executable to path
            binEntry = {
              enable = true;
              # Set executable name
              name = "fsg";
            };

            desktopEntry = {
              enable = true;
              name = "Nixcraft FSG";
              extraConfig = {
                # TODO: fix icons not working
                # icon = "${inputs.self}/assets/minecraft/dirt.svg";
                terminal = true;
              };
            };
          };
        };
      };
    };
  };
}

```