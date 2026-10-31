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
        paper = {
          enable = lib.mkEnableOption "paper";

          buildNumber = lib.mkOption {
            type = lib.types.either lib.types.int lib.types.nonEmptyStr;
            default = config.paper.meta.build.build;
            defaultText = ''<inferred>'';
          };

          minecraftVersion =
            flakeArgs.config.nixcraft.lib.options.minecraftVersionDyn
            // {
              defaultText = ''<inferred>'';
            };

          _serverJar = lib.mkOption {
            readOnly = true;
            type = lib.types.package;
            default = pkgs.fetchurl {
              inherit (config.paper.meta.build) url hash;
            };
            defaultText = ''serverJar'';
          };

          _mainClass = lib.mkOption {
            readOnly = true;
            type = lib.types.nonEmptyStr;
            default = config.paper.meta.mainClass;
            defaultText = ''<inferred>'';
          };

          meta = lib.mkOption {
            type = lib.types.attrs;
            readOnly = true;
            default = {
              build = sources.paper.builds."${config.paper.minecraftVersion}" or null;
              mainClass = "io.papermc.paperclip.Paperclip";
            };
            defaultText = ''meta'';
          };
        };
      };

      config = lib.mkMerge [
        {
          paper = {
            minecraftVersion = lib.mkOptionDefault config.version;
          };
        }

        (lib.mkIf config.paper.enable (lib.mkMerge [
          {
            java.mainClass = lib.mkForce null;
            java.jar = config.mainJar;
            mainJar = config.paper._serverJar;
          }
        ]))

        (let
          prefixMsg = "instance '${config.name}'";
        in {
          _module.check = lib.all (a: a) [
            (lib.assertMsg (config.paper.enable -> (builtins.elem config.paper.minecraftVersion sources.paper.versions))
              "${prefixMsg}: Paper server does not support Minecraft version '${config.paper.minecraftVersion}'.")
          ];
        })
      ];
    })
  ];
}
