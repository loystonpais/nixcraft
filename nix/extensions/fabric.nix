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
        fabricLoader = {
          enable = lib.mkEnableOption "fabric loader";

          version =
            flakeArgs.config.nixcraft.lib.options.fabricLoaderVersionDyn
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
            defaultText = ''meta'';
            default =
              {
                clientMainClass = "net.fabricmc.loader.impl.launch.knot.KnotClient";
                serverMainClass = "net.fabricmc.loader.impl.launch.knot.KnotServer";
              }
              // {
                lock = sources.fabric.loaders.${config.fabricLoader.version};
                mappings = sources.fabric.mappings.${config.fabricLoader.minecraftVersion};
              };
          };
        };
      };

      config = lib.mkMerge [
        {
          fabricLoader = {
            minecraftVersion = lib.mkOptionDefault config.version;
            _instanceType = config._instanceType;
          };
        }

        (lib.mkIf config.fabricLoader.enable (lib.mkMerge [
          {
            libraries = config.fabricLoader.finalLibraries;

            fabricLoader.finalLibraries = let
              inherit (flakeArgs.config.nixcraft.lib.maven) mkLibPath;
              dependencies =
                config.fabricLoader.meta.lock.dependencies.common
                ++ config.fabricLoader.meta.lock.dependencies.${config.fabricLoader._instanceType}
                ++ (config.fabricLoader.meta.mappings or [])
                ++ [config.fabricLoader.meta.lock.name];
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
              java.mainClass = config.fabricLoader.meta.clientMainClass;
            }
          ]))

          (lib.mkIf (config._instanceType == "server") (lib.mkMerge [
            {
              java.jar = lib.mkForce null;
              java.mainClass = config.fabricLoader.meta.serverMainClass;
            }
          ]))
        ]))
      ];
    })
  ];

  nixcraft.docs.examples.client.fabric = {
    version = "1.21.1";
    fabricLoader = {
      enable = true;
      version = "latest";
    };
    desktopEntry.enable = true;
  };

  nixcraft.docs.readme.sections.fabric = {
    order = 60;
    template = ''
      ### Fabric Mod Loader

      Enables Fabric mod loading for client or server instances. Setting `fabricLoader.version = "latest"` automatically resolves the latest compatible loader for your Minecraft version.

      ```nix
      { ... }: {
        nixcraft.client.instances.fabric = {{ examples.client.fabric | to_nix | indent(2) }};
      }
      ```
    '';
  };
}
