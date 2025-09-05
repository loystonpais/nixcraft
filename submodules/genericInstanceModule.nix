{
  lib,
  pkgs,
  forgeLoaderModule,
  fabricLoaderModule,
  quiltLoaderModule,
  mrpackModule,
  javaSettingsModule,
  fileModule,
  fetchSha1,
  sources,
  ...
}: let
  inherit (lib) escapeShellArg filterAttrs;
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

      quiltLoader = lib.mkOption {
        type = with lib.types; (submodule quiltLoaderModule);
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
        type = with lib.types; (submodule mrpackModule);
        default = {
          enable = false;
        };
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

      files = lib.mkOption {
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

      runtimePrograms = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [];
      };

      finalFileCopyShellScript = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        description = ''
          Shell script that places "copy" files
        '';
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
        # Prevents file from being GC-ed
        files.".nixcraft/manifest-version-data.json" = {
          source =
            fetchSha1 sources.normalized-manifest.versions.${config.version};
          method = "default";
        };

        # Set the default java package for client instances
        # TODO: Fix this stupidity
        java.package = lib.mkOptionDefault (pkgs."jdk${toString config.meta.versionData.javaVersion.majorVersion}");

        binEntry.name = lib.mkOptionDefault "nixcraft-${config._instanceType}-${name}";
      }

      # Settings stuff that the user usually doesn't need to alter
      {
        # Set LD_LIBRARY_PATH env var from libs
        envVars.LD_LIBRARY_PATH = lib.makeLibraryPath config.libs;

        # Add busybox to runtime programs (needed for init script)
        runtimePrograms = with pkgs; [busybox];

        # Set PATH from runtime programs
        envVars.PATH = lib.makeBinPath config.runtimePrograms;
      }

      # Forge loader stuff
      {
        forgeLoader.minecraftVersion = lib.mkOptionDefault config.version;
      }

      # fabric loader stuff
      {
        fabricLoader = {
          minecraftVersion = lib.mkOptionDefault config.version;
          _instanceType = config._instanceType;
        };
      }

      # quilt loader stuff
      {
        quiltLoader = {
          minecraftVersion = lib.mkOptionDefault config.version;
          _instanceType = config._instanceType;
        };
      }

      (lib.mkIf config.fabricLoader.enable {
        # java.cp = listJarFilesRecursive config.fabricLoader._impurePackage;
        java.cp = config.fabricLoader.classes;
      })

      (lib.mkIf config.quiltLoader.enable {
        java.cp = config.quiltLoader.classes;
      })

      (lib.mkIf config.mrpack.enable {
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

        version = config.mrpack.minecraftVersion;

        files = lib.mkMerge [
          {
            # Prevents file from being GC-ed
            ".nixcraft/mrpack".source = config.mrpack.file;
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
              builtins.mapAttrs (placePath: path: {
                method = "copy";
                source = path;
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

      {
        finalFileCopyShellScript = let
          script =
            lib.concatMapAttrsStringSep "\n" (
              name: file: let
                absolutePath = "${config.absoluteDir}/${file.target}";
                dirName = builtins.dirOf absolutePath;
              in ''
                ${lib.optionalString file.force ''
                  if [ -e ${escapeShellArg absolutePath} ] || [ -L ${escapeShellArg absolutePath} ]; then
                    echo "Forcing replacement of ${absolutePath}"
                    rm -rf ${escapeShellArg absolutePath}
                  fi
                ''}

                if [ ! -e ${escapeShellArg absolutePath} ] && [ ! -L ${escapeShellArg absolutePath} ]; then
                  mkdir -p ${escapeShellArg dirName}
                  echo "Placing file (once) ${absolutePath}"
                  cp ${escapeShellArg file.source} ${escapeShellArg absolutePath}
                  chmod u+w ${escapeShellArg absolutePath}
                fi
              ''
            )
            (filterAttrs (name: file: file.enable && file.method == "copy") config.files);
        in ''
          mkdir -p ${escapeShellArg config.absoluteDir}
          ${script}
        '';
      }

      # TODO: find correct way to do validations
      (let
        prefixMsg = "${config._instanceType} instance '${config.name}'";
      in {
        _module.check = lib.all (a: a) [
          # If more than one type of mod loader is enabled then fail
          (
            let
              enabledLoaders = lib.count (modLoader: modLoader.enable) [
                config.forgeLoader
                config.fabricLoader
                config.quiltLoader
              ];
            in
              # count of enabled mod loaders must be below or equal to 1
              lib.assertMsg (enabledLoaders <= 1)
              "${prefixMsg}: can't have multiple (${toString enabledLoaders}) mod loaders enabled at the same time."
          )
        ];
      })
    ];
  }
