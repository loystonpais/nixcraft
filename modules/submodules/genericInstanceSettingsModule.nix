{
  lib,
  pkgs,
  forgeLoaderModule,
  fabricLoaderModule,
  mrpackModule,
  javaSettingsModule,
  fileModule,
  ...
}: let
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.nixcraft.filesystem) listJarFilesRecursive;
in
  {
    name,
    config,
    ...
  }: {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
      };

      version = lib.mkOption {
        type = lib.nixcraft.types.minecraftVersion;
      };

      fabricLoader = lib.mkOption {
        type = with lib.types; nullOr (submodule fabricLoaderModule);
        default = null;
      };

      forgeLoader = lib.mkOption {
        type = with lib.types; nullOr (submodule forgeLoaderModule);
        default = null;
      };

      mrpack = lib.mkOption {
        type = with lib.types; nullOr (submodule mrpackModule);
        default = null;
      };

      envVars =
        lib.nixcraft.options.envVars
        // {
          default = {};
        };

      dirFiles = lib.mkOption {
        type = with lib.types; attrsOf (submodule fileModule);
        default = {};
      };

      java = lib.mkOption {
        type = lib.types.submodule javaSettingsModule;
      };

      _instanceType = lib.mkOption {
        type = lib.types.enum ["client" "server"];
      };

      libs = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [];
      };
    };

    config = lib.mkMerge [
      # Set values from mrpack
      (lib.mkIf (config.mrpack != null) {
        fabricLoader.version = lib.mkOptionDefault config.mrpack.fabricLoaderVersion;
        fabricLoader.minecraftVersion = lib.mkOptionDefault config.mrpack.minecraftVersion;
        version = lib.mkOptionDefault config.mrpack.minecraftVersion;

        dirFiles = lib.mkMerge [
          # Set overrides
          # TODO: implement client and server only overrides
          (lib.mkIf config.mrpack.placeOverrides (
            let
              parsedMrpack = config.mrpack._parsedMrpack;
              files = listFilesRecursive "${parsedMrpack}/overrides";
            in
              builtins.listToAttrs (
                map (path: let
                  placePath = lib.removePrefix "${parsedMrpack}/overrides/" path;
                in {
                  name = builtins.unsafeDiscardStringContext placePath;
                  value = {
                    # overrides need to be mutable
                    mutable = true;
                    source = path;
                  };
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
                      url = builtins.elemAt fileInfo.downloads 0;
                      sha1 = fileInfo.hashes.sha1;
                    };
                  };
                })
                filesToPlace
              )
          )
        ];
      })

      # Set values from fabricLoader
      (lib.mkIf (config.fabricLoader != null) {
        # List and assign jar files from generated lib dir
        java.cp = listJarFilesRecursive config.fabricLoader._impurePackage;
      })

      # Settings stuff that the user usually doesn't need to alter
      {
        # Set LD_LIBRARY_PATH env var from libs
        envVars.LD_LIBRARY_PATH = lib.makeLibraryPath config.libs;

        # inform fabric about the instance type
        fabricLoader._instanceType = config._instanceType;
      }

      {
        _module.check =
          lib.asserts.assertMsg (!(config.fabricLoader != null && config.forgeLoader != null))
          "Can't have multiple mod loaders enabled";
      }
    ];
  }
