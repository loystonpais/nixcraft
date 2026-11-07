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
        folia = {
          enable = lib.mkEnableOption "folia";

          buildNumber = lib.mkOption {
            type = lib.types.either lib.types.int lib.types.nonEmptyStr;
            default = config.folia.meta.build.build;
            defaultText = ''<inferred>'';
          };

          minecraftVersion =
            flakeArgs.config.nixcraft.lib.options.foliaVersionDyn
            // {
              defaultText = ''<inferred>'';
            };

          _serverJar = lib.mkOption {
            readOnly = true;
            type = lib.types.package;
            default = pkgs.fetchurl {
              inherit (config.folia.meta.build) url hash;
            };
            defaultText = ''serverJar'';
          };

          _mainClass = lib.mkOption {
            readOnly = true;
            type = lib.types.nonEmptyStr;
            default = config.folia.meta.mainClass;
            defaultText = ''<inferred>'';
          };

          meta = lib.mkOption {
            type = lib.types.attrs;
            readOnly = true;
            default = {
              build = sources.folia.builds."${config.folia.minecraftVersion}" or null;
              mainClass = "io.papermc.paperclip.Paperclip";
            };
            defaultText = ''meta'';
          };
        };
      };

      config = lib.mkMerge [
        {
          folia = {
            minecraftVersion = lib.mkOptionDefault config.version;
          };
        }

        (lib.mkIf config.folia.enable (lib.mkMerge [
          {
            java.mainClass = lib.mkForce null;
            java.jar = config.mainJar;
            mainJar = config.folia._serverJar;
          }

          (lib.mkIf (config.folia.meta.build ? server) {
            files."cache/${config.folia.meta.build.server.filename}".source = pkgs.fetchurl {
              name = config.folia.meta.build.server.filename;
              inherit (config.folia.meta.build.server) url hash;
            };
          })
        ]))

        (let
          prefixMsg = "instance '${config.name}'";
        in {
          _module.check = lib.all (a: a) [
            (lib.assertMsg (config.folia.enable -> (builtins.elem config.folia.minecraftVersion sources.folia.versions))
              "${prefixMsg}: Folia server does not support Minecraft version '${config.folia.minecraftVersion}'.")
          ];
        })
      ];
    })
  ];
}
