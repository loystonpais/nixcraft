{
  config,
  lib,
  ...
} @ flakeArgs: let
  inherit (config.nixcraft) sources;
in {
  nixcraft.server.instance.extensions = [
    ({
      name,
      config,
      pkgs,
      lib,
      ...
    }: {
      options = {
        purpur = {
          enable = lib.mkEnableOption "Purpur";

          minecraftVersion =
            flakeArgs.config.nixcraft.lib.options.minecraftVersionDyn
            // {
              defaultText = ''<inferred>'';
            };

          _serverJar = lib.mkOption {
            readOnly = true;
            type = lib.types.package;
            default = pkgs.fetchurl {
              inherit (config.purpur.meta.build) url hash;
            };
            defaultText = ''serverJar'';
          };

          meta = lib.mkOption {
            type = lib.types.attrs;
            readOnly = true;
            default = {
              build = sources.purpur.builds."${config.purpur.minecraftVersion}" or null;
            };
            defaultText = ''meta'';
          };
        };
      };

      config = lib.mkMerge [
        {
          purpur = {
            minecraftVersion = lib.mkOptionDefault config.version;
          };
        }

        (lib.mkIf config.purpur.enable (lib.mkMerge [
          {
            java.mainClass = lib.mkForce null;
            java.jar = config.mainJar;
            mainJar = config.purpur._serverJar;
          }
        ]))

        (let
          prefixMsg = "instance '${config.name}'";
        in {
          _module.check = lib.all (a: a) [
            (lib.assertMsg (config.purpur.enable -> (builtins.elem config.purpur.minecraftVersion sources.purpur.versions))
              "${prefixMsg}: Purpur server does not support Minecraft version '${config.purpur.minecraftVersion}'.")
          ];
        })
      ];
    })
  ];

  nixcraft.docs.examples.server.purpur = {
    version = "1.21.1";
    agreeToEula = true;
    purpur.enable = true;
    java.memory = 4096;
    serverProperties = {
      motd = "Purpur Server";
      "max-players" = 50;
    };
  };

  nixcraft.docs.readme.sections.purpur = {
    order = 64;
    template = ''
      ### Purpur Server

      Runs a Purpur server:

      ```nix
      nixcraft.server.instances.purpur = {{ examples.server.purpur | to_nix }};
      ```
    '';
  };
}
