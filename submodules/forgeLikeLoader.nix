# Shared logic for Forge-like loaders (Forge, NeoForge).
#
# Both loaders come in (up to) two flavours:
#   - legacy:    no installer; launched through LaunchWrapper with a tweak class (Forge < 1.13).
#   - installer: an installer jar generates patched jars at runtime
#                (ForgeWrapper on the client, `--installServer` on the server).
#
# Loader-specific modules only need to set `meta.sources` (and optionally tweak the
# legacy/launch settings); everything the instance modules consume is derived here.
{
  lib,
  sources,
  pkgs,
  ...
}: {config, ...}: let
  inherit (lib.nixcraft.maven) mkLibPath;
  inherit (lib.nixcraft.minecraftVersion) grEq;

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
  installerCoord = let
    parts = lib.splitString ":" config.meta.loaders.installer;
  in {
    groupPath = builtins.replaceStrings ["."] ["/"] (builtins.elemAt parts 0);
    artifact = builtins.elemAt parts 1;
    version = builtins.elemAt parts 2;
  };
in {
  options = {
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
      type = lib.types.attrsOf lib.nixcraft.types.library;
      readOnly = true;
    };

    finalInstallerLibraries = lib.mkOption {
      type = lib.types.attrsOf lib.nixcraft.types.library;
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
        default = (config.meta.loaders.installer or null) == null;
        defaultText = lib.literalExpression "(config.meta.loaders.installer or null) == null";
      };

      sources = lib.mkOption {
        type = lib.types.attrs;
        readOnly = true;
      };

      loaders = lib.mkOption {
        type = lib.types.attrs;
        readOnly = true;
        default = config.meta.sources.loaders.${config.version};
        defaultText = lib.literalExpression "config.meta.sources.loaders.\${config.version}";
        description = "Metadata for the selected loader version.";
      };

      mainClass = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = config.meta.loaders.mainClass or "io.github.zekerzhayard.forgewrapper.installer.Main";
        defaultText = lib.literalExpression ''config.meta.loaders.mainClass or "io.github.zekerzhayard.forgewrapper.installer.Main"'';
      };
    };
  };

  config = lib.mkIf config.enable (lib.mkMerge [
    {
      version = lib.mkDefault config.meta.sources.game_versions.${config.minecraftVersion};

      finalLibraries = mkLibraries ((config.meta.loaders.dependencies or []) ++ config.extraDependencies);

      finalInstallerLibraries = mkLibraries (config.meta.loaders.installerDependencies or []);

      installerJar =
        if config.meta.isLegacy
        then null
        else
          pkgs.fetchurl {
            inherit (sources.libraries.${config.meta.loaders.installer}) url hash;
          };
    }

    {
      clientArguments =
        if config.meta.isLegacy
        then lib.optionals (config.legacy.tweakClass != null) ["--tweakClass" config.legacy.tweakClass]
        else let
          minecraftArguments =
            lib.filterAttrs
            (_: value: !(lib.hasInfix "\${" value))
            (config.meta.loaders.minecraftArguments or {});
          arguments = lib.concatLists (lib.mapAttrsToList (flag: value: [flag value]) minecraftArguments);
        in
          (lib.optionals (!(minecraftArguments ? "--launchTarget") && config.defaultLaunchTarget != null)
            ["--launchTarget" config.defaultLaunchTarget])
          ++ arguments;

      # Forge >= 1.17 / NeoForge write an args file; older Forge installers produce a runnable jar.
      meta.server = let
        inherit (installerCoord) groupPath artifact version;
        usesArgsFile = grEq config.minecraftVersion "1.17";
      in {
        installMarker =
          if usesArgsFile
          then "libraries/${groupPath}/${artifact}/${version}/unix_args.txt"
          else "${artifact}-${version}.jar";

        javaArguments =
          if usesArgsFile
          then ["@${config.meta.server.installMarker}"]
          else ["-jar" config.meta.server.installMarker];
      };
    }
  ]);
}
