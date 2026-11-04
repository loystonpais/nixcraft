{
  config,
  lib,
  ...
} @ flakeArgs: let
  inherit (config.nixcraft) sources;
in {
  nixcraft.instance.extensions = [
    ({
      name,
      config,
      pkgs,
      lib,
      ...
    }: let
        mrpackSubmodule = {
          name,
          config,
          ...
        }: {
          options = {
            enable = lib.mkEnableOption "enable mrpack";

            file = lib.mkOption {
              type = lib.types.package;
            };

            minecraftVersion = flakeArgs.config.nixcraft.lib.options.minecraftVersionDyn;

            fabricLoaderVersion = lib.mkOption {
              type = lib.types.nullOr flakeArgs.config.nixcraft.lib.types.fabricLoaderVersion;
            };

            quiltLoaderVersion = lib.mkOption {
              type = lib.types.nullOr flakeArgs.config.nixcraft.lib.types.quiltLoaderVersion;
            };

            forgeLoaderVersion = lib.mkOption {
              type = lib.types.nullOr flakeArgs.config.nixcraft.lib.types.forgeLoaderVersion;
            };

            neoforgeLoaderVersion = lib.mkOption {
              type = lib.types.nullOr flakeArgs.config.nixcraft.lib.types.neoforgeLoaderVersion;
            };

            enableOptionalMods = (lib.mkEnableOption "optional mods") // {default = true;};

            placeOverrides = (lib.mkEnableOption "placing overrides") // {default = true;};

            _parsedMrpack = lib.mkOption {
              type = lib.types.attrs;
            };
          };

          config = lib.mkMerge [
            {
              _parsedMrpack = let
                unpacked = flakeArgs.config.nixcraft.lib.builders.unpackMrpack pkgs {src = config.file;};
              in
                flakeArgs.config.nixcraft.lib.builders.parseMrpack pkgs {inherit unpacked;};
              minecraftVersion = lib.mkOptionDefault config._parsedMrpack.minecraftVersion;
            }

            {
              fabricLoaderVersion = lib.mkOptionDefault config._parsedMrpack.fabricLoaderVersion;
            }

            {
              quiltLoaderVersion = lib.mkOptionDefault config._parsedMrpack.quiltLoaderVersion;
            }

            {
              forgeLoaderVersion = lib.mkOptionDefault (
                if config._parsedMrpack.forgeLoaderVersion != null
                then
                  if builtins.elem config._parsedMrpack.forgeLoaderVersion sources.forge.versions
                  then config._parsedMrpack.forgeLoaderVersion
                  else sources.forge.game_versions.${config.minecraftVersion} or null
                else null
              );
            }

            {
              neoforgeLoaderVersion = lib.mkOptionDefault (
                if config._parsedMrpack.neoforgeLoaderVersion != null
                then
                  if builtins.elem config._parsedMrpack.neoforgeLoaderVersion sources.neoforge.versions
                  then config._parsedMrpack.neoforgeLoaderVersion
                  else sources.neoforge.game_versions.${config.minecraftVersion} or null
                else null
              );
            }
          ];
        };
      in {
        options = {
          mrpack = lib.mkOption {
            type = with lib.types; (submodule mrpackSubmodule);
            default = {
              enable = false;
              minecraftVersion = lib.mkOptionDefault config.version;
            };
          };
        };

        config = lib.mkMerge [
          (lib.mkIf config.mrpack.enable (lib.mkMerge [
            # Shared configuration across client and server
            {
              # Settings up fabricloader
              fabricLoader = lib.mkIf (config.mrpack.fabricLoaderVersion != null) {
                enable = true;
                version = config.mrpack.fabricLoaderVersion;
                minecraftVersion = config.mrpack.minecraftVersion;
              };

              # Setting up quilt
              quiltLoader = lib.mkIf (config.mrpack.quiltLoaderVersion != null) {
                enable = true;
                version = config.mrpack.quiltLoaderVersion;
                minecraftVersion = config.mrpack.minecraftVersion;
              };

              # Setting up forge
              forgeLoader = lib.mkIf (config.mrpack.forgeLoaderVersion != null) {
                enable = true;
                version = config.mrpack.forgeLoaderVersion;
                minecraftVersion = config.mrpack.minecraftVersion;
              };

              # Setting up neoforge
              neoForgeLoader = lib.mkIf (config.mrpack.neoforgeLoaderVersion != null) {
                enable = true;
                version = config.mrpack.neoforgeLoaderVersion;
                minecraftVersion = config.mrpack.minecraftVersion;
              };

              version = config.mrpack.minecraftVersion;

              files = lib.mkMerge [
                {
                  # Prevents file from being GC-ed
                  ".nixcraft/mrpack".source = config.mrpack.file;
                  ".nixcraft/mrpack-unpacked".source = config.mrpack._parsedMrpack.src;
                }

                # Set overrides
                (lib.mkIf config.mrpack.placeOverrides (
                  let
                    parsedMrpack = config.mrpack._parsedMrpack;
                    files =
                      if config._instanceType == "client"
                      then parsedMrpack.overrides-plus-client-overrides
                      else parsedMrpack.overrides-plus-server-overrides;
                  in (
                    builtins.mapAttrs (targetPath: sourcePath: {
                      method = lib.mkDefault (
                        # Some mrpacks contain mods, resourcepacks and datapacks in overrides
                        if
                          lib.any (p: lib.hasPrefix p targetPath) [
                            "mods/"
                            "resourcepacks/"
                            "datapacks/"
                          ]
                        then "copy"
                        else "copy-init"
                      );
                      source = sourcePath;
                    })
                    files
                  )
                ))

                # Set mods (files)
                (
                  let
                    parsedMrpack = config.mrpack._parsedMrpack;
                    filesToPlace =
                      lib.filter (
                        attr:
                          (attr.env.${config._instanceType} == "required")
                          || (config.mrpack.enableOptionalMods && attr.env.${config._instanceType} == "optional")
                      )
                      parsedMrpack.index.files;
                  in
                    builtins.listToAttrs (
                      map (fileInfo: {
                        name = fileInfo.path;
                        value = {
                          source = pkgs.fetchurl {
                            urls = fileInfo.downloads;
                            sha1 = fileInfo.hashes.sha1;
                          };
                        };
                      })
                      filesToPlace
                    )
                )
              ];
            }
          ]))
        ];
      })
    ];
}
