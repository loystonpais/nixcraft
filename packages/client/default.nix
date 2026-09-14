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

  isImpure = builtins ? currentSystem;
  homeDir =
    if isImpure
    then builtins.getEnv "HOME"
    else "";
  hasHome = isImpure && homeDir != "";

  externalAssetsDirPrefix =
    if hasHome
    then "${homeDir}/.local/share/nixcraft/client/assets"
    else "/tmp/nixcraft-client-assets";

  externalAssetsLookupPaths =
    if hasHome
    then [
      "${homeDir}/.local/share/PrismLauncher/assets"
      "${homeDir}/.minecraft/assets"
      "/var/cache/nixcraft/asset-objects"
    ]
    else ["/var/cache/nixcraft/asset-objects"];

  authDirPrefix =
    if hasHome
    then "${homeDir}/.local/share/nixcraft/client/auth"
    else "/tmp/nixcraft-client-auth";

  evalPackage = {cfgModules, ...}: let
    evaluated = lib.evalModules {
      modules =
        [
          clientInstanceModule
          {
            version = lib.mkDefault "latest-release";
            absoluteDir = lib.mkDefault (
              if hasHome
              then "${homeDir}/.local/share/nixcraft/client/instances/${name}"
              else "/tmp/nixcraft-client/${name}"
            );
            account = lib.mkDefault {offline = true;};
            binEntry.enable = lib.mkDefault true;
            desktopEntry.enable = lib.mkDefault true;
          }
        ]
        ++ cfgModules;
      specialArgs = {
        shared = {};
        dirPrefix = null;
        inherit
          authDirPrefix
          externalAssetsDirPrefix
          externalAssetsLookupPaths
          name
          pkgs
          lib
          ;
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
  in
    finalEntry;

  extraCombinators = {withConfig, ...}: rec {
    withExternalAssets = withConfig {
      enableExternalAssets = true;
    };

    withCachedAssets = withExternalAssets;

    withNixGL = withConfig {
      enableNixGL = true;
    };

    withRenice = withConfig {
      renice.enable = true;
    };

    online = withConfig {
      account = {
        offline = false;
      };
    };

    withLwjglVersion = ver:
      withConfig {
        lwjgl.version = ver;
      };

    lwjgl3-3-3 = withLwjglVersion "3.3.3";
    lwjgl3-2-2 = withLwjglVersion "3.2.2";

    fsg = withConfig {
      mrpack = {
        enable = true;
        file = pkgs.fetchurl {
          inherit (sources.modrinth."speedrunpack-1-16-1") url sha512;
        };
      };

      files = {
        "mods/fsg-mod.jar".source = pkgs.fetchurl {
          inherit (sources.modrinth."fsg-mod-1-16-1") url sha512;
        };
      };

      java = {
        extraArguments = [
          "-XX:+UseZGC"
          "-XX:+AlwaysPreTouch"
          "-Dgraal.TuneInlinerExploration=1"
          "-XX:NmethodSweepActivity=1"
        ];
        package = pkgs.jdk17;
        maxMemory = 3500;
        minMemory = 3500;
      };

      waywall.enable = true;

      binEntry = {
        name = "fsg";
      };

      desktopEntry = {
        name = "Nixcraft FSG";
        extraConfig = {
          terminal = true;
        };
      };
    };

    rsg = withConfig {
      mrpack = {
        enable = true;
        file = pkgs.fetchurl {
          inherit (sources.modrinth."speedrunpack-1-16-1") url sha512;
        };
      };

      java = {
        extraArguments = [
          "-XX:+UseZGC"
          "-XX:+AlwaysPreTouch"
          "-Dgraal.TuneInlinerExploration=1"
          "-XX:NmethodSweepActivity=1"
        ];
        package = pkgs.jdk17;
        maxMemory = 4000;
        minMemory = 4000;
      };

      waywall.enable = true;

      binEntry = {
        name = "rsg";
      };

      desktopEntry = {
        name = "Nixcraft RSG";
        extraConfig = {
          terminal = true;
        };
      };
    };
  };
in
  (lib.nixcraft.makeInstancePackage {
    inherit sources evalPackage extraCombinators;
  })
  cfg
