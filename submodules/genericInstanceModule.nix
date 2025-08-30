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
        type = lib.types.nonEmptyStr;
        readOnly = true;
        internal = true;
        default = name;
      };

      dir = lib.mkOption {
        type = lib.types.nonEmptyStr;
      };

      absoluteDir = lib.mkOption {
        type = lib.types.nonEmptyStr;
        readOnly = true;
      };

      version = lib.nixcraft.options.minecraftVersionDyn;

      fabricLoader = lib.mkOption {
        type = with lib.types; (submodule fabricLoaderModule);
        default = {
          enable = false;
        };
      };

      forgeLoader = lib.mkOption {
        type = with lib.types; (submodule forgeLoaderModule);
        default = {
          enable = false;
        };
      };

      mrpack = lib.mkOption {
        type = with lib.types; nullOr (submodule mrpackModule);
        default = null;
      };

      binEntry = lib.mkOption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "bin entry";
            name = lib.mkOption {
              type = lib.types.nonEmptyStr;
            };
            finalBin = lib.mkOption {
              type = lib.types.package;
              readOnly = true;
              default = pkgs.writeScriptBin config.binEntry.name config.finalLaunchShellScript;
            };
          };
        };
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

      libs = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [];
      };

      finalLaunchShellCommandString = lib.mkOption {
        type = lib.types.nonEmptyStr;
        readOnly = true;
      };

      finalLaunchShellScript = lib.mkOption {
        type = lib.types.nonEmptyStr;
        readOnly = true;
      };

      _instanceType = lib.mkOption {
        internal = true;
        type = lib.types.enum ["client" "server"];
      };

      meta = {
        versionData = lib.mkOption {
          type = lib.types.attrs;
          readOnly = true;
          default =
            lib.nixcraft.readJSON
            (fetchSha1 sources.normalized-manifest.versions.${config.version});
        };
      };
    };

    config = lib.mkMerge [
      {
        fabricLoader.minecraftVersion = lib.mkOptionDefault config.version;

        forgeLoader.minecraftVersion = lib.mkOptionDefault config.version;

        # Prevents file from being GC-ed
        dirFiles.".nixcraft/manifest-version-data.json".source =
          fetchSha1 sources.normalized-manifest.versions.${config.version};

        # Set the default java package for client instances
        # TODO: Fix this stupidity
        java.package = lib.mkOptionDefault (pkgs."jdk${toString config.meta.versionData.javaVersion.majorVersion}");

        binEntry.name = lib.mkOptionDefault "nixcraft-${config._instanceType}-${name}";
      }

      # Settings stuff that the user usually doesn't need to alter
      {
        # Set LD_LIBRARY_PATH env var from libs
        envVars.LD_LIBRARY_PATH = lib.makeLibraryPath config.libs;

        # inform fabric about the instance type
        fabricLoader._instanceType = config._instanceType;
      }

      (lib.mkIf config.fabricLoader.enable {
        java.cp = listJarFilesRecursive config.fabricLoader._impurePackage;
      })

      # TODO: make mrpack non-nullable
      (lib.mkIf (config.mrpack != null) {
        # Settings up fabricloader
        fabricLoader.enable = config.mrpack._parsedMrpack.fabricLoaderVersion != null;
        fabricLoader.version = config.mrpack.fabricLoaderVersion;
        fabricLoader.minecraftVersion = config.mrpack.minecraftVersion;

        version = config.mrpack.minecraftVersion;

        dirFiles = lib.mkMerge [
          {
            # Prevents file from being GC-ed
            ".nixcraft/mrpack".source = config.mrpack.file;
          }

          # Set overrides
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

      # TODO: find correct way to do validations
      (let
        prefixMsg = "${config._instanceType} instance '${config.name}'";
      in {
        _module.check = lib.all (a: a) [
          # If more than one type of mod loader is enabled then fail
          (
            let
              enabledLoaders = lib.count (modLoader: modLoader.enable) [config.forgeLoader config.fabricLoader];
            in
              # count of enabled mod loaders must be below or equal to 1
              lib.assertMsg (enabledLoaders <= 1)
              "${prefixMsg}: can't have multiple (${toString enabledLoaders}) mod loaders enabled at the same time."
          )
        ];
      })
    ];
  }
