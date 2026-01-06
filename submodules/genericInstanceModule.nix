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
    dirPrefix,
    ...
  }: {
    options = {
      name = lib.mkOption {
        type = lib.types.nonEmptyStr;
        readOnly = true;
        internal = true;
        default = name;
      };

      absoluteDir = lib.mkOption ({
          type = lib.types.pathWith {absolute = true;};
        }
        // (
          if dirPrefix != null
          then {
            default = "${dirPrefix}/${name}";
          }
          else {}
        ));

      version =
        lib.nixcraft.options.minecraftVersionDyn
        // {
          default = "latest-release";
          defaultText = ''latest-release'';
        };

      fabricLoader = lib.mkOption {
        type = with lib.types; (submodule fabricLoaderModule);
        default = {
          enable = false;
          minecraftVersion = lib.mkOptionDefault config.version;
          _instanceType = config._instanceType;
        };
      };

      quiltLoader = lib.mkOption {
        type = with lib.types; (submodule quiltLoaderModule);
        default = {
          enable = false;
          minecraftVersion = lib.mkOptionDefault config.version;
          _instanceType = config._instanceType;
        };
      };

      forgeLoader = lib.mkOption {
        type = with lib.types; (submodule forgeLoaderModule);
        default = {
          enable = false;
          minecraftVersion = lib.mkOptionDefault config.version;
          _instanceType = config._instanceType;
        };
      };

      mrpack = lib.mkOption {
        type = with lib.types; (submodule mrpackModule);
        default = {
          enable = false;
          minecraftVersion = lib.mkOptionDefault config.version;
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
        type = with lib.types;
          attrsOf (submoduleWith {
            modules = [
              fileModule
              ({
                config,
                instanceType,
                ...
              }: {
                options = {
                  method = lib.mkOption {
                    type = lib.types.enum ["copy" "copy-init" "symlink"];
                    default = "symlink";

                    description = ''
                      Method to place the file in target location
                        copy-init     - copy once during init (suitable for config files from modpacks)
                        copy          - copy every rebuild
                        symlink - symlink every rebuild
                    '';
                  };
                };

                config = {
                  _module.check = lib.any (a: a) [
                    (
                      instanceType
                      == "client"
                      -> (lib.assertMsg (
                          !(lib.hasPrefix "saves/" config.target) && config.target != "saves"
                        )
                        "file '${config.target}' is not allowed")
                    )

                    (
                      instanceType
                      == "server"
                      -> (lib.assertMsg (
                          !(lib.hasPrefix "world/" config.target) && config.target != "world"
                        )
                        "file '${config.target}' is not allowed")
                    )
                  ];
                };
              })
            ];
            specialArgs = {
              instanceType = config._instanceType;
            };
          });
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
        description = ''
          Libraries available at runtime
        '';
      };

      runtimePrograms = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [];
      };

      fixBugs =
        (lib.mkEnableOption "fixing trivial bugs if any")
        // {
          default = true;
          internal = true;
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
          defaultText = ''versionData'';
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
        envVars.LD_LIBRARY_PATH = [(lib.makeLibraryPath config.runtimeLibs)];

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
                  # Some mrpacks contain mods,
                  # resourcepacks and datapacks in overrides
                  # Use "copy" on them
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
      })

      (lib.mkIf (config.placeFilesAtActivation) {
        activationShellScript = ''
          ${config.finalFilePlacementShellScript}
        '';
      })

      (lib.mkIf (!config.placeFilesAtActivation) {
        preLaunchShellScript = ''
          ${config.finalFilePlacementShellScript}
        '';
      })

      # file placement logic
      {
        # guard some paths
        files = {
          ".nixcraft".enable = lib.mkForce false;
          ".nixcraft/files".enable = lib.mkForce false;
          ".nixcraft/init".enable = lib.mkForce false;
        };

        finalFilePlacementShellScript = let
          esc = lib.escapeShellArg;
          entryFilePath = "${config.absoluteDir}/.nixcraft/files";
          initFilePath = "${config.absoluteDir}/.nixcraft/init";

          enabledFiles = filterAttrs (name: file: file.enable) config.files;

          files'copy = filterAttrs (name: file: file.method == "copy") enabledFiles;
          files'symlink = filterAttrs (name: file: file.method == "symlink") enabledFiles;
          files'copy-init = filterAttrs (name: file: file.method == "copy-init") enabledFiles;

          files'entries = filterAttrs (name: file: file.method == "copy" || file.method == "symlink") enabledFiles;

          script'copy-init =
            lib.concatMapAttrsStringSep "\n" (name: file: let
              fileAbsPath = "${config.absoluteDir}/${file.target}";
              fileAbsDirPath = builtins.dirOf fileAbsPath;
            in ''
              mkdir -p ${esc fileAbsDirPath}
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
              rm -rf ${esc fileAbsPath}
              ln -s ${esc file.finalSource} ${esc fileAbsPath}
            '')
            files'symlink;
        in ''
          mkdir -p ${esc config.absoluteDir}
          mkdir -p ${esc config.absoluteDir}/.nixcraft

          if [ -f ${esc entryFilePath} ]; then
            while IFS= read -r f; do
                # echo "Removing $f"
                rm -rf "$f"
                rmdir --ignore-fail-on-non-empty "$(dirname "$f")" 2>/dev/null || true
            done < ${esc entryFilePath}
            rm -f ${esc entryFilePath}
          fi

          ### copy ###
          ${script'copy}
          ### copy end ###

          ### symlink ###
          ${script'symlink}
          ### symlink end ###

          ### copy-init ###
          if [ ! -e ${esc initFilePath} ]; then
            ${script'copy-init}
            touch ${esc initFilePath}
          fi
          ### copy-init end ###

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

          # make sure that paths that are enabled don't have any children
          # TODO: move this logic over to a newer module called filesModule
          (
            let
              allPaths = lib.attrNames config.files;

              conflicts =
                lib.filter (
                  path:
                    (config.files.${path}.enable or false)
                    == true
                    && (lib.any (p: p != path && lib.hasPrefix "${path}/" p) allPaths)
                )
                allPaths;

              conflictMessages =
                map (
                  path: let
                    children = lib.filter (p: p != path && lib.hasPrefix "${path}/" p) allPaths;
                  in ''
                    files."${path}" is enabled but it also has children:
                      ${lib.concatStringsSep "\n  " children}
                  ''
                )
                conflicts;
            in
              lib.assertMsg (conflicts == [])
              ''
                ${prefixMsg}: file path conflicts detected:

                ${lib.concatStringsSep "\n\n" conflictMessages}
              ''
          )
        ];
      })
    ];
  }
