# This config showcases several nixcraft's features (home manager only)
{
  config,
  pkgs,
  lib,
  ...
}: let
  # Fetch any mrpack which can be used with both servers and clients!
  simply-optimized-mrpack = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/BYfVnHa7/versions/vZZwrcPm/Simply%20Optimized-1.21.1-5.0.mrpack";
    hash = "sha256-n2BxHMmqpOEMsvDqRRYFfamcDCCT4ophUw7QAJQqXmg=";
  };

  speedrunpack-mrpack = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/1uJaMUOm/versions/5icZYG8d/SpeedrunPack-mc1.16.1-v6.0.0.mrpack";
    hash = "sha256-5cLBucJTaia7tTytrJrUA5Rou/oyLot1umWq/4o+Fuw=";
  };

  fsgmod-jar = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/XZOGBIpM/versions/4IW4nMP3/fsg-mod-5.2.0%2BMC1.16.1.jar";
    hash = "sha256-bA3Y+7OWex8LwEXgMN+7DH6vi6hIoOZ7w3XzA3AE4qg=";
  };

  # A world dir
  mcsr-practice-map = pkgs.fetchzip {
    url = "https://github.com/Dibedy/The-MCSR-Practice-Map/releases/download/1.0.1/MCSR.Practice.v1.0.1.zip";
    stripRoot = false;
    hash = "sha256-ukedZCk6T+KyWqEtFNP1soAQSFSSzsbJKB3mU3kTbqA=";
  };
in {
  config = {
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
          lazymc.enable = true;
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
          files."server.properties".method = lib.mkForce "copy-init";
          binEntry.enable = true;
        };

        # Example server with quilt loader
        quilt-server = {
          enable = true;
          version = "1.21.1";
          quiltLoader = {
            enable = true;
            version = "0.29.1";
          };
        };

        fsg-server = {
          enable = true;
          version = "1.16.1";
          world = mcsr-practice-map;
        };
      };
    };

    client = {
      # Config to share with all instances
      shared = {
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

          files."testfile" = {
            type = "toml";
            text = ''a = 20'';
            value = {
              foo = "hi";
            };
          };

          files."config/entityculling.json" = {
            type = "json";
            value = {
              sleepDelay = lib.mkForce 100;
            };
            method = "symlink";
          };
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
        onepoint6 = {
          enable = true;
          version = "1.6.4";
        };

        onepoint8 = {
          enable = true;
          version = "1.8";
        };

        onepoint12 = {
          enable = true;
          # enableFastAssetDownload = true;
          # assetHash = "sha256-v3pPzxvfo6zO1CWUkAi3RxRh4rE0yMVuKXVhWCwh17U=";
          version = "1.12.1";
        };

        # Example client with quilt loader
        quilt-client = {
          enable = true;
          version = "1.21.1";
          quiltLoader = {
            enable = true;
            version = "0.29.1";
          };
        };

        quilt-mrpack = {
          enable = true;
          mrpack = {
            enable = true;
            file = builtins.fetchurl {
              url = "https://cdn.modrinth.com/data/BHSdOzJg/versions/ARqyXvUd/Feather-V3.1.1-Quilt.mrpack";
              sha256 = "sha256:19arvv3c0bgbsdz1l8399rqf4bfyslnzsybrfscd9xf2g3c953nh";
            };
          };
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
            file = speedrunpack-mrpack;
          };

          # Set saves
          saves = {
            "Practice Map" = mcsr-practice-map;
          };

          # place custom files
          files = {
            # mods can also be manually set
            "mods/fsg-mod.jar".source = fsgmod-jar;

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

        rsg = {
          enable = true;

          _classSettings = {
            fullscreen = true;
            uuid = "2909ee95-d459-40c4-bcbb-65a0cc413110";
            username = "loystonlive";
          };

          mrpack = {
            enable = true;
            file = speedrunpack-mrpack;
          };

          # place custom files
          files = {
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
            package = pkgs.jdk17;
            maxMemory = 4000;
            minMemory = 4000;
          };

          waywall.enable = true;

          binEntry = {
            enable = true;
            name = "rsg";
          };

          desktopEntry = {
            enable = true;
            name = "Nixcraft RSG";
            extraConfig = {
              terminal = true;
            };
          };
        };
      };
    };
  };
}
