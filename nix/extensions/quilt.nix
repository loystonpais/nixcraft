{
  config,
  lib,
  ...
} @ flakeArgs: let
  inherit (config.nixcraft) sources;
in {
  nixcraft.instance.extensions = [
    ({
      config,
      pkgs,
      lib,
      ...
    }: {
      options = {
        quiltLoader = {
          enable = lib.mkEnableOption "quilt loader";

          version =
            flakeArgs.config.nixcraft.lib.options.quiltLoaderVersionDyn
            // {
              default = "latest";
              defaultText = "latest";
            };

          minecraftVersion = flakeArgs.config.nixcraft.lib.options.minecraftVersionDyn;

          hash = lib.mkOption {
            type = lib.types.nonEmptyStr;
            default = lib.fakeHash;
          };

          _instanceType = lib.mkOption {
            type = lib.types.enum ["client" "server"];
            internal = true;
          };

          finalLibraries = lib.mkOption {
            type = lib.types.attrsOf flakeArgs.config.nixcraft.lib.types.library;
            readOnly = true;
          };

          meta = lib.mkOption {
            type = lib.types.attrs;
            readOnly = true;
            default = {
              lock = sources.quilt.loaders.${config.quiltLoader.version};
              mappings = sources.quilt.mappings.${config.quiltLoader.minecraftVersion};
            };
            defaultText = ''meta'';
          };
        };
      };

      config = lib.mkMerge [
        {
          quiltLoader = {
            minecraftVersion = lib.mkOptionDefault config.version;
            _instanceType = config._instanceType;
          };
        }

        (lib.mkIf config.quiltLoader.enable (lib.mkMerge [
          {
            libraries = config.quiltLoader.finalLibraries;

            quiltLoader.finalLibraries = let
              inherit (flakeArgs.config.nixcraft.lib.maven) mkLibPath;
              dependencies =
                config.quiltLoader.meta.lock.dependencies.common
                ++ config.quiltLoader.meta.lock.dependencies.${config.quiltLoader._instanceType}
                ++ (config.quiltLoader.meta.mappings or [])
                ++ [config.quiltLoader.meta.lock.name];
            in
              lib.listToAttrs (map (library:
                lib.nameValuePair library {
                  enable = true;
                  native = false;
                  relativePath = mkLibPath library;
                  jar = pkgs.fetchurl {
                    inherit (sources.libraries.${library}) url hash;
                  };
                })
              dependencies);
          }

          (lib.mkIf (config._instanceType == "client") (lib.mkMerge [
            {
              java.mainClass = config.quiltLoader.meta.lock.mainClass.client;
            }
          ]))

          (lib.mkIf (config._instanceType == "server") (lib.mkMerge [
            {
              java.jar = lib.mkForce null;
              java.mainClass = config.quiltLoader.meta.lock.mainClass.server;
            }
          ]))
        ]))
      ];
    })
  ];

  nixcraft.docs.examples.client.quilt = {
    version = "1.21.1";
    quiltLoader = {
      enable = true;
      version = "latest";
    };
    desktopEntry.enable = true;
  };

  nixcraft.docs.readme.sections.quilt = {
    order = 61;
    template = ''
      ### Quilt Mod Loader

      Enables Quilt mod loading for client or server instances.

      ```nix
      { ... }: {
        nixcraft.client.instances.quilt = {{ examples.client.quilt | to_nix | indent(2) }};
      }
      ```
    '';
  };
}
