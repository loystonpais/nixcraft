{
  lib,
  pkgs,
  forgeLoaderModule,
  fabricLoaderModule,
  mrpackModule,
  javaSettingsModule,
  fileModule,
  fetchSha1,
  sources,
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
        type = with lib.types; (submodule fabricLoaderModule);
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

      meta = {
        versionData = lib.mkOption {
          type = lib.types.attrs;
          readOnly = true;
          default =
            lib.nixcraft.readJSON
            (fetchSha1 sources.normalized-manifest.versions.${config.version.value});
        };
      };
    };

    config = lib.mkMerge [
      # Set default options
      # TODO: set more default options
      {
        fabricLoader.minecraftVersion = lib.mkOptionDefault config.version.value;
      }

      # Set values from mrpack
      # TODO: make mrpack non-nullable
      (lib.mkIf (config.mrpack != null) {
        # Settings up fabricloader
        fabricLoader.enable = config.mrpack._parsedMrpack.fabricLoaderVersion != null;
        fabricLoader.version = config.mrpack.fabricLoaderVersion;
        fabricLoader.minecraftVersion = config.mrpack.minecraftVersion;

        version = config.mrpack.minecraftVersion;

        dirFiles = lib.mkMerge [
          # Set overrides
          # TODO: implement client and server only overrides (FIXED)
          (lib.mkIf config.mrpack.placeOverrides (
            let
              parsedMrpack = config.mrpack._parsedMrpack;
              files = let
                overrides = builtins.listToAttrs (
                  map
                  (path: {
                    name = builtins.unsafeDiscardStringContext (lib.removePrefix "${parsedMrpack}/overrides/" path);
                    value = path;
                  }) (listFilesRecursive "${parsedMrpack}/overrides")
                );

                client-overrides = builtins.listToAttrs (
                  map (path: {
                    name = builtins.unsafeDiscardStringContext (lib.removePrefix "${parsedMrpack}/client-overrides/" path);
                    value = path;
                  }) (listFilesRecursive "${parsedMrpack}/client-overrides")
                );

                server-overrides = builtins.listToAttrs (
                  map (path: {
                    name = builtins.unsafeDiscardStringContext (lib.removePrefix "${parsedMrpack}/server-overrides/" path);
                    value = path;
                  }) (listFilesRecursive "${parsedMrpack}/server-overrides")
                );

                overrides-plus-client-overrides = overrides // client-overrides;
                overrides-plus-server-overrides = overrides // server-overrides;
              in
                if config._instanceType == "client"
                then overrides-plus-client-overrides
                else overrides-plus-server-overrides;
            in (builtins.mapAttrs (placePath: path: {
                mutable = true;
                source = path;
              })
              files)
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

      {
        # Set the default java package for client instances
        # TODO: Fix this stupidity
        java.package = lib.mkOptionDefault (pkgs."jdk${toString config.meta.versionData.javaVersion.majorVersion}");
      }

      # if fabric loader is enabled
      # Set values from fabricLoader
      (lib.mkIf config.fabricLoader.enable (lib.mkMerge [
        # if the instance type is a client
        (lib.mkIf (config._instanceType == "client") {
          # List and assign jar files from generated lib dir
          java.cp = listJarFilesRecursive config.fabricLoader._impurePackage;
        })

        # if the instance type is server
        (lib.mkIf (config._instanceType == "server") {
          # Pass the server jar to java
          # # not do this  #  java.extraArguments = ["-jar" "${config.fabricLoader._impurePackage}"];
          # List and assign jar files from generated lib dir
          java.cp = listJarFilesRecursive config.fabricLoader._impurePackage;
        })
      ]))

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
