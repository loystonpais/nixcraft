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

          (lib.mkIf (config.purpur.meta.build ? server) {
            files."cache/${config.purpur.meta.build.server.filename}".source = pkgs.fetchurl {
              name = config.purpur.meta.build.server.filename;
              inherit (config.purpur.meta.build.server) url hash;
            };
          })
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
}
