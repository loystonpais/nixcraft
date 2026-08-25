{
  pkgs,
  lib,
  submodules,
  sources,
  cfg ? {},
  name ? "default",
  ...
}: let
  clientInstanceModule = submodules.clientInstanceModule;

  makeClient = currentCfg: let
    cfgModules = lib.toList currentCfg;

    evaluated = lib.evalModules {
      modules =
        [
          clientInstanceModule
          {
            version = lib.mkDefault "latest-release";
            absoluteDir = lib.mkDefault "/tmp/nixcraft-client/${name}";
            account = lib.mkDefault {};
            binEntry.enable = lib.mkDefault true;
            desktopEntry.enable = lib.mkDefault true;
          }
        ]
        ++ cfgModules;
      specialArgs = {
        shared = {};
        dirPrefix = null;
        clientExternalAssetDirPrefix = "/tmp/nixcraft-client-assets";
        inherit name;
        inherit pkgs;
        inherit lib;
      };
    };

    # Combines both bin entry and desktop entry
    finalEntry = pkgs.symlinkJoin {
      name = name;
      paths = [
        (
          pkgs.makeDesktopItem (evaluated.config.desktopEntry.extraConfig
            // {
              exec = "${lib.getExe evaluated.config.binEntry.finalBin}";
              desktopName = evaluated.config.desktopEntry.name;
              name = evaluated.config.binEntry.name;
            })
        )
        evaluated.config.binEntry.finalBin
      ];

      meta.mainProgram = evaluated.config.binEntry.name;

      passthru = {
        evaluatedModule = evaluated;
      };
    };

    # Fluent modifiers
    combinators = rec {
      withConfig = newCfg: makeClient (cfgModules ++ (lib.toList newCfg));
      overrideConfig = withConfig;

      withExternalAssets = withConfig {
        enableExternalAssets = true;
      };

      withCachedAssets = withExternalAssets;

      withVersion = ver:
        withConfig {
          version = ver;
        };

      latestRelease = withVersion "latest-release";
      latestSnapshot = withVersion "latest-snapshot";

      versionShortcuts = let
        sanitizeVersion = v: "v" + (builtins.replaceStrings ["." "-" " "] ["-" "-" "-"] v);
        allVersions = sources.normalized-manifest.versionListOrdered;
      in
        lib.listToAttrs (map (ver: lib.nameValuePair (sanitizeVersion ver) (withVersion ver)) allVersions);
    };
  in
    finalEntry // combinators // combinators.versionShortcuts;
in
  makeClient cfg
