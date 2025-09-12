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
  mkLibDir,
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

      placeFilesAtActivation =
        (lib.mkEnableOption "placing files during activation")
        // {
          default = false;
        };

      preLaunchShellScript = lib.mkOption {
        type = lib.types.lines;
        default = '''';
      };

      activationShellScript = lib.mkOption {
        type = lib.types.lines;
        default = '''';
      };

      java = lib.mkOption {
        type = lib.types.submodule javaSettingsModule;
      };

      libraries = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [];
      };

      mainJar = lib.mkOption {
        type = lib.types.path;
      };

      runtimeLibs = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [];
      };

      runtimePrograms = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [];
      };

      finalLaunchShellCommandString = lib.mkOption {
        type = lib.types.lines;
        readOnly = true;
      };

      finalPreLaunchShellScript = lib.mkOption {
        type = lib.types.lines;
        readOnly = true;
      };

      finalLaunchShellScript = lib.mkOption {
        type = lib.types.lines;
        readOnly = true;
      };

      finalActivationShellScript = lib.mkOption {
        type = lib.types.lines;
        readOnly = true;
      };

      finalFilePlacementShellScript = lib.mkOption {
        type = lib.types.lines;
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
        };

        # Set the default java package for client instances
        # is this Good enough ?
        java.package = lib.mkOptionDefault (let
          inherit (lib.nixcraft.minecraftVersion) lsEq;
          versionLsOrEqTo = lsEq config.version;

          # Sometimes java version is not mentioned in the manifest ???
          versionFromManifest = config.meta.versionData.javaVersion.majorVersion or null;

          versionGuessed =
            if versionLsOrEqTo "1.16.5"
            then 8
            else if versionLsOrEqTo "1.17.1"
            then 16
            else if versionLsOrEqTo "1.20.6"
            then 17
            else 21;

          finalVersion =
            if versionFromManifest != null
            then versionFromManifest
            else versionGuessed;

          javaPkg = pkgs."jdk${toString finalVersion}" or pkgs.jdk;
        in
          javaPkg);

        binEntry.name = lib.mkOptionDefault "nixcraft-${config._instanceType}-${name}";
      }

      # Settings stuff that the user usually doesn't need to alter
      {
        # Set LD_LIBRARY_PATH env var from libs
        envVars.LD_LIBRARY_PATH = lib.makeLibraryPath config.runtimeLibs;

        # Add busybox to runtime programs (needed for init script)
        runtimePrograms = with pkgs; [busybox];

        # Set PATH from runtime programs
        envVars.PATH = lib.makeBinPath config.runtimePrograms;

        # Make lib dir out of all libraries and then
        # pass them to java class paths
        java.cp = let
          normalLibDir = mkLibDir {
            libraries = config.libraries;
          };

          # Fix bug with jopt-simple which gets an invalid module name
          # due to it being a symlink
          patchedForgeLibDir = normalLibDir.overrideAttrs (final: prev: {
            buildCommand = ''
              ${prev.buildCommand}
              if [ -d $out/net/sf/jopt-simple ]; then
                chmod -R u+w $out/net/sf/jopt-simple
                for f in $(find $out/net/sf/jopt-simple -type l); do
                  cp --remove-destination $(readlink $f) $f
                done
              fi
            '';
          });

          libDir =
            if config.forgeLoader.enable
            then patchedForgeLibDir
            else normalLibDir;
        in
          (listJarFilesRecursive libDir)
          ++ [config.mainJar];
      }

      # Forge loader stuff
      {
        forgeLoader = {
          minecraftVersion = lib.mkOptionDefault config.version;
          _instanceType = config._instanceType;
        };
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
                method = lib.mkDefault "copy-init";
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

      (lib.mkIf (config.placeFilesAtActivation) {
        activationShellScript = ''
          ${config.finalFilePlacementShellScript}
        '';
      })

      (lib.mkIf (config.placeFilesAtActivation == false) {
        preLaunchShellScript = ''
          ${config.finalFilePlacementShellScript}
        '';
      })

      {
        finalFilePlacementShellScript = let
          esc = lib.escapeShellArg;
          entryFilePath = "${config.absoluteDir}/.nixcraft/files";
          initFilePath = "${config.absoluteDir}/.nixcraft/init";

          enabledFiles = filterAttrs (name: file: file.enable) config.files;

          files'copy = filterAttrs (name: file: file.method == "copy") enabledFiles;
          files'symlink = filterAttrs (name: file: file.method == "symlink") enabledFiles;
          files'copy-init = filterAttrs (name: file: file.method == "copy-init") enabledFiles;

          files'entries = filterAttrs (name: file: file.method == "copy-init" || file.method == "symlink") enabledFiles;

          script'copy-init =
            lib.concatMapAttrsStringSep "\n" (name: file: let
              fileAbsPath = "${config.absoluteDir}/${file.target}";
              fileAbsDirPath = builtins.dirOf fileAbsPath;
            in ''
              mkdir -p ${esc fileAbsDirPath}
              # echo "copy-init (once) ${esc file.finalSource} -> ${esc fileAbsPath}"
              rm -rf ${esc fileAbsPath}
              cp ${esc file.finalSource} ${esc fileAbsPath}
              chmod u+w ${esc fileAbsPath}
            '')
            files'copy-init;

          script'copy =
            lib.concatMapAttrsStringSep "\n" (name: file: let
              fileAbsPath = "${config.absoluteDir}/${file.target}";
              fileAbsDirPath = builtins.dirOf fileAbsPath;
            in ''
              mkdir -p ${esc fileAbsDirPath}
              # echo "copy (always) ${esc file.finalSource} -> ${esc fileAbsPath}"
              rm -rf ${esc fileAbsPath}
              cp ${esc file.finalSource} ${esc fileAbsPath}
              chmod u+w ${esc fileAbsPath}
            '')
            files'copy;

          script'symlink =
            lib.concatMapAttrsStringSep "\n" (name: file: let
              fileAbsPath = "${config.absoluteDir}/${file.target}";
              fileAbsDirPath = builtins.dirOf fileAbsPath;
            in ''
              mkdir -p ${esc fileAbsDirPath}
              # echo "symlink ${esc file.finalSource} -> ${esc fileAbsPath}"
              rm -rf ${esc fileAbsPath}
              ln -s ${esc file.finalSource} ${esc fileAbsPath}
            '')
            files'symlink;
        in ''
          mkdir -p ${esc config.absoluteDir}
          mkdir -p ${esc config.absoluteDir}/.nixcraft

          if [ -f ${esc entryFilePath} ]; then
            # echo "Removing old files..."
            while IFS= read -r f; do
                # echo "Removing $f"
                rm -rf "$f"
                rmdir --ignore-fail-on-non-empty "$(dirname "$f")" 2>/dev/null || true
            done < ${esc entryFilePath}
            rm -f ${esc entryFilePath}
          fi

          # echo "Placing files for" ${esc config.name}

          ${script'copy}
          ${script'symlink}

          if [ ! -e ${esc initFilePath} ]; then
            ${script'copy-init}
            touch ${esc initFilePath}
          fi

          rm -rf ${esc entryFilePath}
          cp ${builtins.toFile "entries" (
            lib.concatMapAttrsStringSep "\n" (name: file: "${config.absoluteDir}/${file.target}") files'entries
          )}  ${esc entryFilePath}
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
