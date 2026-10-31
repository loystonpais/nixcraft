{
  config,
  lib,
  ...
} @ flakeArgs: let
  inherit (config.nixcraft) sources;
in {
  nixcraft.instance.module = {
    name,
    config,
    dirPrefix ? null,
    readOnlyName ? true,
    pkgs,
    moduleType ? "package",
    ...
  }: let
    inherit (lib) escapeShellArg;
  in {
    imports = flakeArgs.config.nixcraft.instance.extensions;

    options = {
      _moduleType = lib.mkOption {
        type = lib.types.enum ["nixos" "home-manager" "package"];
        readOnly = true;
        internal = true;
        default = moduleType;
      };

      name = lib.mkOption {
          type = lib.types.nonEmptyStr;
          readOnly = readOnlyName;
          internal = true;
          default = name;
        };

        absoluteDir = lib.mkOption ({
            type = lib.types.pathWith {absolute = true;};
          }
          // (
            if dirPrefix != null
            then {
              default = "${dirPrefix}/${config.name}";
            }
            else {}
          ));

        version =
          flakeArgs.config.nixcraft.lib.options.minecraftVersionDyn
          // {
            default = "latest-release";
            defaultText = ''latest-release'';
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
          flakeArgs.config.nixcraft.lib.options.envVars
          // {
            default = {};
          };

        mods = lib.mkOption {
          type = with lib.types; listOf (oneOf [path package]);
          default = [];
        };

        preLaunchShellScript = lib.mkOption {
          type = lib.types.lines;
          default = '''';
        };

        activationShellScript = lib.mkOption {
          type = lib.types.lines;
          default = '''';
        };

        extraArguments = lib.mkOption {
          type = with lib.types; listOf nonEmptyStr;
          default = [];
        };

        libraries = lib.mkOption {
          type = lib.types.attrsOf flakeArgs.config.nixcraft.lib.types.library;
          default = {};
        };

        mutableLibrariesDir = lib.mkEnableOption ''
          placing libraries in the instance's mutable libraries directory
          and using those paths on the classpath
        '';

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

        jemalloc = {
          enable = lib.mkEnableOption "jemalloc";
        };

        renice = {
          enable = lib.mkEnableOption "renicing the instance process before launch";
          priority = lib.mkOption {
            type = lib.types.int;
            default = -20;
            description = "Niceness priority value (between -20 and 19). Lower values mean higher priority.";
          };
          wrappedBinPath = lib.mkOption {
            type = lib.types.path;
            default = "/run/wrappers/bin/nixcraft-renice";
          };
          sudoLookupPaths = lib.mkOption {
            type = with lib.types; listOf path;
            default = [
              "/run/wrappers/bin/sudo"
              "/usr/bin/sudo"
              "/bin/sudo"
            ];
          };
        };

        launchPrefix = lib.mkOption {
          type = with lib.types;
            attrsOf (submodule ({name, ...}: {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  default = name;
                  readOnly = true;
                };
                enable = (lib.mkEnableOption "launch prefix entry") // {default = true;};
                priority = lib.mkOption {
                  type = lib.types.int;
                  default = 1000;
                };
                command = lib.mkOption {
                  type = with lib.types; listOf (oneOf [str path package]);
                };
                separator = lib.mkOption {
                  type = with lib.types; nullOr str;
                  default = "--";
                };
                envVars =
                  flakeArgs.config.nixcraft.lib.options.envVars
                  // {
                    default = {};
                  };
              };
            }));
          default = {};
        };

        finalLibraries = lib.mkOption {
          type = lib.types.attrsOf flakeArgs.config.nixcraft.lib.types.library;
          readOnly = true;
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

        meta = {
          versionData = lib.mkOption {
            type = lib.types.attrs;
            readOnly = true;
            default = sources.mojang.versions.${config.version};
            defaultText = ''sources.mojang.versions.''${config.version}'';
          };
        };

        # Internal options

        _instanceType = lib.mkOption {
          type = lib.types.enum ["client" "server"];
          internal = true;
          readOnly = true;
        };

        fixBugs =
          (lib.mkEnableOption "fixing trivial bugs if any")
          // {
            default = true;
            internal = true;
          };

        dedupeLibraries =
          (lib.mkEnableOption "deduplication of libraries")
          // {
            default = true;
            internal = true;
          };
      };

      config = lib.mkMerge [
        {
          binEntry.name = lib.mkOptionDefault "nixcraft-${config._instanceType}-${config.name}";
        }

        (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
          envVars.DYLD_LIBRARY_PATH = [(lib.makeLibraryPath config.runtimeLibs)];
        })

        # When linux or freebsd
        (lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
          envVars.LD_LIBRARY_PATH = [(lib.makeLibraryPath config.runtimeLibs)];
        })

        {
          envVars.PATH = lib.makeBinPath config.runtimePrograms;

          runtimePrograms = with pkgs; [
            # Add utils to runtime programs (needed for init script)
            bash
            coreutils
            findutils
            gnugrep
            gnused
            gawk

            # Some modded client / server seem to need this
            # Fixes: WARNING: Unable to retrieve infocmp for type xterm-kitty
            ncurses
          ];
        }

        (let
          libDir =
            if config.mutableLibrariesDir
            then "${config.absoluteDir}/libraries"
            else flakeArgs.config.nixcraft.lib.builders.mkLibDir pkgs {normalizedLibraries = config.finalLibraries;};

          paths =
            map (l: "${libDir}/${l.relativePath}")
            (builtins.filter (l: l.enable && !l.native) (builtins.attrValues config.finalLibraries));
        in {
          # When forge or neoforge is enabled, let forge/neoforge handle the libraries and classpath
          java.cp = lib.mkIf (!config.forgeLoader.enable && !config.neoForgeLoader.enable) (paths ++ [config.mainJar]);
        })

        (lib.mkIf config.mutableLibrariesDir {
          files = let
            enabledLibs =
              builtins.filter (l: l.enable && !l.native)
              (builtins.attrValues (config.finalLibraries));
          in
            builtins.listToAttrs (
              map (l:
                lib.nameValuePair "libraries/${l.relativePath}" {
                  source = l.jar;
                })
              enabledLibs
            );
        })

        # Compute finalLibraries from libraries with optional deduplication
        {
          finalLibraries =
            if config.dedupeLibraries
            then
              flakeArgs.config.nixcraft.lib.maven.dedupeNormalizedLibraryAttrs {
                inherit (config) libraries;
              }
            else config.libraries;
        }

        # Place mods from .mods
        {
          files = builtins.listToAttrs (
            map (modPath: {
              name = builtins.unsafeDiscardStringContext "mods/${builtins.baseNameOf (toString modPath)}";
              value = {
                source = modPath;
              };
            })
            config.mods
          );
        }

        (lib.mkIf (config.jemalloc.enable) {
          envVars.LD_PRELOAD = lib.mkBefore ["${pkgs.jemalloc}/lib/libjemalloc.so"];
        })

        (lib.mkIf (config.renice.enable) {
          preLaunchShellScript = lib.mkBefore ''
            if [ -x ${escapeShellArg config.renice.wrappedBinPath} ]; then
              ${escapeShellArg config.renice.wrappedBinPath} --priority ${toString config.renice.priority} -p $$
            else
              for sudoPath in ${lib.concatMapStringsSep " " escapeShellArg config.renice.sudoLookupPaths}; do
                if [ -x "$sudoPath" ]; then
                  "$sudoPath" ${pkgs.util-linux}/bin/renice --priority ${toString config.renice.priority} -p $$
                  break
                fi
              done
            fi
          '';
        })

        # Validations
        (let
          prefixMsg = "${config._instanceType} instance '${config.name}'";
        in {
          _module.check = lib.all (a: a) [
            # If more than one type of mod loader is enabled then fail
            (
              let
                enabledLoaders = lib.count (modLoader: modLoader.enable) [
                  config.forgeLoader
                  config.neoForgeLoader
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
    };
}
