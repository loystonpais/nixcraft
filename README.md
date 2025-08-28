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

      * To run an instance: simply execute the run file found within the instance dir
        Ex: ~/.local/share/nixcraft/client/instances/my-instance/run

      * Read files found under modules/submodules for more options
      * Read modules/submodules/genericInstanceModule.nix for generic options
      */

      enable = true;

      server = {
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
            agreeToEula = true;
          };

          # Example server with simply-optimized mrpack loaded
          simop = {
            enable = true;
            agreeToEula = true;
            mrpack.file = simply-optimized-mrpack;
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
            agreeToEula = true;
            java.memory = 2000;
            serverProperties.online-mode = false;
          };
        };
      };

      client = {
        # Config to share with all instances
        shared = {
          dirFiles."screenshots".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Pictures";

          # Common account
          account = {
            username = "loystonlive";
            uuid = "2909ee95-d459-40c4-bcbb-65a0cc413110";
            offline = true;
          };
        };

        instances = {
          # Example instance with simply-optimized mrpack
          simop = {
            enable = true;

            mrpack.file = simply-optimized-mrpack;
            fabricLoader.hash = "sha256-2UAt7yP28tIQb6OTizbREVnoeu4aD8U1jpy7DSKUyVg=";
          };

          # Example bare bones client
          nomods = {
            enable = true;
            version = "1.21.1";
          };

          # Audio doesn't seem to work in old versions
          old = {
            enable = true;
            version = "1.7.1";
          };

          one-three = {
            enable = true;
            version = "1.13";
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

            mrpack.file = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/1uJaMUOm/versions/jIrVgBRv/SpeedrunPack-mc1.16.1-v5.3.0.mrpack";
              hash = "sha256-uH/fGFrqP2UpyCupyGjzFB87LRldkPkcab3MzjucyPQ=";
            };

            fabricLoader.hash = "sha256-go+Y7m4gD+4ALBuYxKhM9u8Oo/T8n5LAYO3QWAMfnMQ=";

            envVars = {
              __GL_THREADED_OPTIMIZATIONS = "0";
            };

            # place custom files
            dirFiles = {
              # mods can also be manually set
              "mods/fsg-mod.jar".source = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/XZOGBIpM/versions/TcTlTNlF/fsg-mod-5.1.0%2BMC1.16.1.jar";
                hash = "sha256-gQfbJMsp+QEnuz4T7dC1jEVoGRa5dmK4fXO/Ea/iM+A=";
              };

              # setting config files
              "config/mcsr/standardsettings.json".source = ./standardsettings.json;
              "options.txt" = {
                source = ./options.txt;
                mutable = true;
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
            # Waywall can be executed by runnig waywall-run file found within the game dir
            # Ex: ~/.local/share/nixcraft/client/instances/fsg/waywall-run
            waywall.enable = true;

            # Game is passed to the gpu (set if you have nvidia gpu)
            enableNvidiaOffload = true;
          };
        };
      };
    };
  };
}


```