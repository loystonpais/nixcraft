{
  pkgs,
  lib,
  submodules,
  sources,
  cfg ? {},
  name ? "default",
  ...
}: let
  serverInstanceModule = submodules.serverInstanceModule;

  isImpure = builtins ? currentSystem;
  homeDir =
    if isImpure
    then builtins.getEnv "HOME"
    else "";
  hasHome = isImpure && homeDir != "";

  evalPackage = {cfgModules, ...}: let
    evaluated = lib.evalModules {
      modules =
        [
          serverInstanceModule
          {
            version = lib.mkDefault "latest-release";
            absoluteDir = lib.mkDefault (
              if hasHome
              then "${homeDir}/.local/share/nixcraft/server/instances/${name}"
              else "/tmp/nixcraft-server/${name}"
            );
            binEntry.enable = lib.mkDefault true;
          }
        ]
        ++ cfgModules;
      specialArgs = {
        shared = {};
        dirPrefix = null;
        inherit name pkgs lib;
      };
    };

    finalBin = evaluated.config.binEntry.finalBin;
  in
    finalBin
    // {
      passthru =
        (finalBin.passthru or {})
        // {
          evaluatedModule = evaluated;
        };
    };

  extraCombinators = {withConfig, ...}: rec {
    agreeToEula = withConfig {
      agreeToEula = true;
    };

    withPaper = withConfig {
      paper.enable = true;
    };
    paper = withPaper;

    withLazymc = withConfig {
      lazymc.enable = true;
    };
    lazymc = withLazymc;

    withNoGui = withConfig {
      noGui = true;
    };

    withGui = withConfig {
      noGui = false;
    };

    withServerProperties = props:
      withConfig {
        serverProperties = props;
      };

    withWorld = world:
      withConfig {
        inherit world;
      };
  };
in
  (lib.nixcraft.makeInstancePackage {
    inherit sources evalPackage extraCombinators;
  })
  cfg
