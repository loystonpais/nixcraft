# Nixcraft (WIP)

Nixcraft - A declarative minecraft launcher in nix

Warning - This project is in a usable state but stil a work in progress. Do expect things to break.

## Features

  1. Supports clients and servers
  2. Supports Mod Loaders (Fabric loader, Quilt loader & paper servers)
  3. Supports Modpacks (modrinth .mrpack)
  4. MCSR - Supports speedrunning related content

## TODO

  1. Support Forge
  2. Support more modpacks such as packwiz

## Usage

You can run a minecraft instance right off the bat.

Example one-liner commands to run in the current dir

### server

```sh
nix run --impure --expr '(builtins.getFlake "github:loystonpais/nixcraft").outputs.packages.x86_64-linux.server.override { cfg = { version = "1.21.1"; absoluteDir = builtins.getEnv "PWD"; agreeToEula = true; }; }'
```

### client

```sh
nix run --impure --expr '(builtins.getFlake "github:loystonpais/nixcraft").outputs.packages.x86_64-linux.client.override { cfg = { version = "1.16.1"; account = {  }; absoluteDir = builtins.getEnv "PWD"; }; }'
```

## Usage (nix profile)

This in my opinion is the best way to install a nixcraft instance.

Pros:

  1. Easy to use and convenient
  2. Automatically adds binary and desktop item to path
  3. No nixos rebuilding required
  4. Not garbage collected until removed
  5. No root needed

Here's how you would install a client. Same applies for a server instance.

```nix
nix profile add --impure --expr '
(builtins.getFlake "github:loystonpais/nixcraft").outputs.packages.x86_64-linux.client.override {
  name = "profile-demo";
  cfg = {
    version = "1.16.1";
    account = {};
    desktopEntry.name = "Nixcraft Profile Demo";
    absoluteDir = "${builtins.getEnv "HOME"}/profile-demo"; # game dir set to $HOME/profile-demo
  };
}
'
```

Upon running the above command a package `profile-demo` will be added to your profile. To remove it, simply run `nix profile remove profile-demo`.

Checkout the home-manager usage for additional configuration options.

## Usage (home-manager)

Nixcraft module can be integrated with home-manager and nixos modules.

See `docs` for all available options.

```nix
# in flake.nix inputs add
nixcraft = {
    url = "github:loystonpais/nixcraft";
    inputs.follows.nixpkgs = "nixpkgs"; # Set correct nixpkgs name
};

```

```nix
# Config showcasing nixcraft's features
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

          # Example server with quilt loader
          quilt-server = {
            enable = true;
            version = "1.21.1";
            quiltLoader = {
              enable = true;
              version = "0.29.1";
            };
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

          # Example client with quilt loader
          quilt-client = {
            enable = true;
            version = "1.21.1";
            quiltLoader = {
              enable = true;
              version = "0.29.1";
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
              file = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/1uJaMUOm/versions/jIrVgBRv/SpeedrunPack-mc1.16.1-v5.3.0.mrpack";
                hash = "sha256-uH/fGFrqP2UpyCupyGjzFB87LRldkPkcab3MzjucyPQ=";
              };
            };

            # Set custom world saves
            saves = {
              "Practice Map" = pkgs.fetchzip {
                url = "https://github.com/Dibedy/The-MCSR-Practice-Map/releases/download/1.0.1/MCSR.Practice.v1.0.1.zip";
                stripRoot = false;
                hash = "sha256-ukedZCk6T+KyWqEtFNP1soAQSFSSzsbJKB3mU3kTbqA=";
              };
            };

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

          rsg = {
            enable = true;

            _classSettings = {
              fullscreen = true;
              uuid = "2909ee95-d459-40c4-bcbb-65a0cc413110";
              username = "loystonlive";
            };

            mrpack = {
              enable = true;
              file = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/1uJaMUOm/versions/jIrVgBRv/SpeedrunPack-mc1.16.1-v5.3.0.mrpack";
                hash = "sha256-uH/fGFrqP2UpyCupyGjzFB87LRldkPkcab3MzjucyPQ=";
              };
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
  };
}
```