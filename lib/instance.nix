{
  lib,
  sources,
  nixcraft,
  ...
}: let
  inherit
    (builtins)
    readDir
    elem
    mapAttrs
    readFile
    fromJSON
    ;
  inherit
    (lib)
    mapAttrs'
    nameValuePair
    foldl'
    filter
    getAttrs
    mkMerge
    foldAttrs
    mapAttrsToList
    ;
in
  with nixcraft; {
    makeInstancePackage = {
      sources ? sources,
      evalPackage,
      extraCombinators ? (_: {}),
    }: let
      makeInstance = currentCfg: let
        cfgModules = lib.toList currentCfg;

        withConfig = newCfg: makeInstance (cfgModules ++ (lib.toList newCfg));

        baseCombinators = rec {
          inherit withConfig;
          overrideConfig = withConfig;

          withVersion = ver:
            withConfig {
              version = ver;
            };

          latestRelease = withVersion "latest-release";
          latestSnapshot = withVersion "latest-snapshot";

          withFabric = withConfig {
            fabricLoader.enable = true;
          };

          withForge = withConfig {
            forgeLoader.enable = true;
          };

          withNeoForge = withConfig {
            neoForgeLoader.enable = true;
          };

          withQuilt = withConfig {
            quiltLoader.enable = true;
          };

          withMrpack = file:
            withConfig {
              mrpack = {
                enable = true;
                inherit file;
              };
            };

          withMods = mods:
            withConfig {
              inherit mods;
            };

          pwd = let
            pwdEnv =
              if builtins ? currentSystem
              then builtins.getEnv "PWD"
              else "";
            pwdPath = /. + "${pwdEnv}";
            configFile =
              if pwdEnv != "" && builtins.pathExists (pwdPath + "/nixcraft.nix")
              then pwdPath + "/nixcraft.nix"
              else if pwdEnv != "" && builtins.pathExists (pwdPath + "/default.nix")
              then pwdPath + "/default.nix"
              else null;
          in
            if pwdEnv == ""
            then throw "nixcraft: .pwd requires evaluation with '--impure' to read PWD"
            else
              withConfig (
                [
                  {
                    absoluteDir = pwdEnv;
                  }
                ]
                ++ (lib.optional (configFile != null) configFile)
              );

          portable = pwd;

          versionShortcuts = let
            sanitizeVersion = v: "v" + (builtins.replaceStrings ["." "-" " "] ["-" "-" "-"] v);
            allVersions = sources.mojang.meta.versions;
          in
            lib.listToAttrs (map (ver: lib.nameValuePair (sanitizeVersion ver) (withVersion ver)) allVersions);
        };

        allCombinators = baseCombinators // (extraCombinators withConfig);

        evalResult = evalPackage {
          inherit cfgModules makeInstance allCombinators withConfig;
        };

        package = evalResult.package or evalResult;
        evaluatedModule = evalResult.evaluatedModule or (evalResult.passthru.evaluatedModule or null);
      in
        package
        // (
          if evaluatedModule != null
          then {inherit evaluatedModule;}
          else {}
        )
        // allCombinators
        // baseCombinators.versionShortcuts;
    in
      makeInstance;
  }
