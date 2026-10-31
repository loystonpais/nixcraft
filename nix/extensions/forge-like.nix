# Shared logic for Forge-like loaders (Forge, NeoForge).
#
# Both loaders come in (up to) two flavours:
#   - legacy:    no installer; launched through LaunchWrapper with a tweak class (Forge < 1.13).
#   - installer: an installer jar generates patched jars at runtime
#                (ForgeWrapper on the client, `--installServer` on the server).
#
# Loader-specific modules invoke this helper with their loaderName and sources,
# providing full loader options and runtime lifecycle management.
{
  config,
  lib,
  ...
}: let
  inherit (config.nixcraft) sources;
  inherit (config.nixcraft.lib) maven minecraftVersion options types;
in {
  nixcraft.lib.forgeLike = {
    # Shared logic generator for Forge-like loaders (Forge, NeoForge).
    mkLoaderModule = {
      pkgs,
      loaderName,
      description ? loaderName,
      versionDynOption,
      loaderSources,
    }: {config, ...}: let
      loader = config.${loaderName};
      inherit (maven) mkLibPath;
      inherit (minecraftVersion) grEq;

      mkLibrary = name: {
        enable = true;
        native = false;
        relativePath = mkLibPath name;
        jar = pkgs.fetchurl {
          inherit (sources.libraries.${name}) url hash;
        };
      };

      mkLibraries = names: lib.genAttrs names mkLibrary;

      # "group:artifact:version:installer" -> { groupPath, artifact, version }
      installerCoord =
        if (loader.meta.loaders.installer or null) != null
        then let
          parts = lib.splitString ":" loader.meta.loaders.installer;
        in {
          groupPath = builtins.replaceStrings ["."] ["/"] (builtins.elemAt parts 0);
          artifact = builtins.elemAt parts 1;
          version = builtins.elemAt parts 2;
        }
        else {
          groupPath = "";
          artifact = "";
          version = "";
        };
    in {
      options.${loaderName} = {
        enable = lib.mkEnableOption description;

        version = versionDynOption;

        minecraftVersion = options.minecraftVersionDyn;

        _instanceType = lib.mkOption {
          type = lib.types.enum ["client" "server"];
          internal = true;
        };

        extraDependencies = lib.mkOption {
          type = with lib.types; listOf str;
          internal = true;
          default = [];
          description = "Extra maven coordinates added on top of the loader's runtime dependencies.";
        };

        legacy = {
          tweakClass = lib.mkOption {
            type = lib.types.nullOr lib.types.nonEmptyStr;
            internal = true;
            default = null;
          };
          serverMainClass = lib.mkOption {
            type = lib.types.nullOr lib.types.nonEmptyStr;
            internal = true;
            default = null;
          };
        };

        defaultLaunchTarget = lib.mkOption {
          type = lib.types.nullOr lib.types.nonEmptyStr;
          internal = true;
          default = null;
          description = "Client launch target used when the loader metadata doesn't specify one.";
        };

        replacesMinecraftJar = lib.mkOption {
          type = lib.types.bool;
          internal = true;
          default = false;
          description = ''
            Whether the patched jar produced by the installer fully replaces the vanilla jar
            on the classpath (the vanilla jar must then be left out so it doesn't shadow it).
          '';
        };

        clientArguments = lib.mkOption {
          type = with lib.types; listOf str;
          readOnly = true;
          description = "Loader specific game arguments for the client.";
        };

        finalLibraries = lib.mkOption {
          type = lib.types.attrsOf types.library;
          readOnly = true;
        };

        finalInstallerLibraries = lib.mkOption {
          type = lib.types.attrsOf types.library;
          readOnly = true;
        };

        installerJar = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          readOnly = true;
        };

        meta = {
          server = {
            installMarker = lib.mkOption {
              type = lib.types.str;
              readOnly = true;
              description = "Path (relative to the instance dir) that exists once the server is installed.";
            };
            javaArguments = lib.mkOption {
              type = with lib.types; listOf str;
              readOnly = true;
              description = "Java arguments (relative to the instance dir) that launch the installed server.";
            };
          };

          isLegacy = lib.mkOption {
            type = lib.types.bool;
            readOnly = true;
            default = (loader.meta.loaders.installer or null) == null;
            defaultText = lib.literalExpression "(config.meta.loaders.installer or null) == null";
          };

          sources = lib.mkOption {
            type = lib.types.attrs;
            readOnly = true;
            default = loaderSources;
            defaultText = "loaderSources";
          };

          loaders = lib.mkOption {
            type = lib.types.attrs;
            readOnly = true;
            default = loader.meta.sources.loaders.${loader.version};
            defaultText = lib.literalExpression "config.meta.sources.loaders.\${config.version}";
          };

          rawInstallerLibraries = lib.mkOption {
            type = lib.types.attrs;
            readOnly = true;
            default = loader.meta.loaders.installerLibraries or {};
            defaultText = lib.literalExpression "config.meta.loaders.installerLibraries or {}";
          };

          rawLibraries = lib.mkOption {
            type = lib.types.attrs;
            readOnly = true;
            default = loader.meta.loaders.libraries;
            defaultText = lib.literalExpression "config.meta.loaders.libraries";
          };

          mainClass = lib.mkOption {
            type = lib.types.nullOr lib.types.nonEmptyStr;
            readOnly = true;
            default =
              if (loader.meta.loaders.mainClass or null) != null
              then loader.meta.loaders.mainClass
              else "io.github.zekerzhayard.forgewrapper.installer.Main";
            defaultText = lib.literalExpression ''
              if (config.meta.loaders.mainClass or null) != null
              then config.meta.loaders.mainClass
              else "io.github.zekerzhayard.forgewrapper.installer.Main"
            '';
          };
        };
      };

      config = lib.mkMerge [
        {
          ${loaderName} = {
            minecraftVersion = lib.mkOptionDefault config.version;
            _instanceType = config._instanceType;
          };
        }

        (lib.mkIf loader.enable (lib.mkMerge [
          {
            ${loaderName} = {
              version = lib.mkDefault loader.meta.sources.game_versions.${loader.minecraftVersion};

              finalLibraries = mkLibraries ((loader.meta.loaders.dependencies or []) ++ loader.extraDependencies);

              finalInstallerLibraries = mkLibraries (loader.meta.loaders.installerDependencies or []);

              installerJar =
                if loader.meta.isLegacy
                then null
                else
                  pkgs.fetchurl {
                    inherit (sources.libraries.${loader.meta.loaders.installer}) url hash;
                  };

              clientArguments =
                if loader.meta.isLegacy
                then lib.optionals (loader.legacy.tweakClass != null) ["--tweakClass" loader.legacy.tweakClass]
                else let
                  minecraftArguments =
                    lib.filterAttrs
                    (_: value: !(lib.hasInfix "\${" value))
                    (loader.meta.loaders.minecraftArguments or {});
                  arguments = lib.concatLists (lib.mapAttrsToList (flag: value: [flag value]) minecraftArguments);
                in
                  (lib.optionals (!(minecraftArguments ? "--launchTarget") && loader.defaultLaunchTarget != null)
                    ["--launchTarget" loader.defaultLaunchTarget])
                  ++ arguments;

              meta.server = let
                inherit (installerCoord) groupPath artifact version;
                usesArgsFile = grEq loader.minecraftVersion "1.17";
              in {
                installMarker =
                  if usesArgsFile
                  then "libraries/${groupPath}/${artifact}/${version}/unix_args.txt"
                  else "${artifact}-${version}.jar";

                javaArguments =
                  if usesArgsFile
                  then ["@${loader.meta.server.installMarker}"]
                  else ["-jar" loader.meta.server.installMarker];
              };
            };
          }

          # Common instance configuration
          {
            libraries = loader.finalLibraries;
            mutableLibrariesDir = true;

            # Only runtime libraries belong on the classpath.
            java.cp =
              map
              (l: "${config.absoluteDir}/libraries/${l.relativePath}")
              (builtins.filter
                (l: l.enable && !l.native)
                (builtins.attrValues config.finalLibraries));

            # Place installer libraries in mutable libraries dir
            files = let
              enabledLibs =
                builtins.filter (l: l.enable && !l.native)
                (builtins.attrValues (
                  if loader.meta.isLegacy
                  then {}
                  else loader.finalInstallerLibraries
                ));
            in
              builtins.listToAttrs (
                map (l:
                  lib.nameValuePair "libraries/${l.relativePath}" {
                    source = l.jar;
                  })
                enabledLibs
              );
          }

          {
            # These files bug when they are symlinks, so copy them instead
            files = let
              installerLibs =
                if loader.meta.isLegacy
                then {}
                else loader.finalInstallerLibraries;
              librariesToCopy =
                builtins.filter
                (l:
                  l.enable
                  && !l.native
                  && (
                    lib.hasInfix "jopt-simple" l.relativePath
                    || lib.hasInfix "org/ow2/asm/asm/" l.relativePath
                  ))
                (builtins.attrValues (installerLibs // config.finalLibraries));
            in
              builtins.listToAttrs (
                map (l:
                  lib.nameValuePair "libraries/${l.relativePath}" {
                    method = "copy";
                  })
                librariesToCopy
              );
          }

          # Legacy loaders patch vanilla Minecraft classes at runtime.
          (lib.mkIf loader.meta.isLegacy {
            java.cp = [config.mainJar];
          })

          # Client-specific configuration
          (lib.mkIf (config._instanceType == "client") (lib.mkMerge [
            {
              java.mainClass = loader.meta.mainClass;
              extraArguments = loader.clientArguments;
            }

            (lib.mkIf (!loader.meta.isLegacy) {
              mutableLibrariesDir = true;

              java.cp = lib.mkIf (!loader.replacesMinecraftJar) [config.mainJar];

              java.D = {
                "forgewrapper.librariesDir" = "${config.absoluteDir}/libraries";
                "forgewrapper.minecraft" = config.mainJar;
                "forgewrapper.installer" = loader.installerJar;
                "libraryDirectory" = "${config.absoluteDir}/libraries";
              };
            })
          ]))

          # Server-specific configuration
          (lib.mkIf (config._instanceType == "server") (lib.mkMerge [
            {
              java.jar = lib.mkForce null;
            }

            (lib.mkIf loader.meta.isLegacy {
              java.mainClass = loader.legacy.serverMainClass;
            })

            (lib.mkIf (!loader.meta.isLegacy) {
              java.mainClass = lib.mkForce null;
              java.cp = lib.mkForce [];
              java.extraArguments = lib.mkAfter loader.meta.server.javaArguments;

              preLaunchShellScript = lib.mkAfter ''
                mkdir -p ${lib.escapeShellArg config.absoluteDir}
                if [ ! -e ${lib.escapeShellArg "${config.absoluteDir}/${loader.meta.server.installMarker}"} ]; then
                  echo "Installing ${loader.version} server..."
                  (cd ${lib.escapeShellArg config.absoluteDir} && \
                    ${lib.escapeShellArg "${config.java.package}/bin/java"} -jar ${lib.escapeShellArg loader.installerJar} \
                      --installServer ${lib.escapeShellArg config.absoluteDir})
                fi
              '';
            })
          ]))
        ]))
      ];
    };
  };
}
