# Nixcraft (WIP)

Example home manager configuration (might break)

```nix
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  simply-optimized-mrpack = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/BYfVnHa7/versions/vZZwrcPm/Simply%20Optimized-1.21.1-5.0.mrpack";
    hash = "sha256-n2BxHMmqpOEMsvDqRRYFfamcDCCT4ophUw7QAJQqXmg=";
  };
in {
  imports = [
    inputs.nixcraft.homeModules.default
  ];

  config = {
    nixcraft = {
      enable = true;

      server = {
        instances = {
          smp = {
            enable = true;

            settings.version = "1.21.1";

            agreeToEula = true;

            settings.fabricLoader = {
              enable = true;
              version = "0.17.2";
              hash = "sha256-hCQBYgdxfBqskQ100Ae0xfCbAZB2xkCxdKyImpkiB4U=";
            };
          };
        };

        instances = {
          simop = {
            enable = true;
            settings.mrpack.file = simply-optimized-mrpack;
            agreeToEula = true;
            settings.java.memory = 2000;
            settings.fabricLoader.hash = "sha256-2UAt7yP28tIQb6OTizbREVnoeu4aD8U1jpy7DSKUyVg";
          };
        };
      };

      client = {
        instances = {
          simop = {
            enable = true;

            settings.mrpack.file = simply-optimized-mrpack;

            settings.fabricLoader.hash = "sha256-2UAt7yP28tIQb6OTizbREVnoeu4aD8U1jpy7DSKUyVg=";
          };

          fsg = {
            enable = true;

            settings = {
              version = "1.16.1";

              mrpack.file = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/1uJaMUOm/versions/jIrVgBRv/SpeedrunPack-mc1.16.1-v5.3.0.mrpack";
                hash = "sha256-uH/fGFrqP2UpyCupyGjzFB87LRldkPkcab3MzjucyPQ=";
              };

              fabricLoader.hash = "sha256-go+Y7m4gD+4ALBuYxKhM9u8Oo/T8n5LAYO3QWAMfnMQ=";

              envVars = {
                __GL_THREADED_OPTIMIZATIONS = "0";
              };

              dirFiles = {
                "mods/fsg-mod.jar".source = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/XZOGBIpM/versions/TcTlTNlF/fsg-mod-5.1.0%2BMC1.16.1.jar";
                  hash = "sha256-gQfbJMsp+QEnuz4T7dC1jEVoGRa5dmK4fXO/Ea/iM+A=";
                };

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
                package = pkgs.jdk17;
                maxMemory = 3500;
                minMemory = 3500;
              };
            };

            waywall.enable = true;

            enableNvidiaOffload = true;
          };
        };
      };
    };
  };
}
```