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
    mkExportedEnvVars = variables: let
      absoluteVariables = lib.mapAttrs (n: lib.toList) variables;

      allVariables = lib.zipAttrsWith (n: lib.concatLists) [
        absoluteVariables
      ];

      exportVariables =
        lib.mapAttrsToList (
          n: v: ''export ${n}="${lib.concatStringsSep ":" v}"''
        )
        allVariables;
    in
      lib.concatStringsSep "\n" exportVariables;
    mkLaunchPrefixList = launchPrefix: let
      enabledPrefixes =
        lib.sort (a: b: a.priority < b.priority)
        (lib.filter (w: w.enable) (builtins.attrValues launchPrefix));

      launchPrefixTokens =
        lib.concatMap (
          w: let
            envTokens =
              if w.envVars != {}
              then ["env"] ++ (lib.mapAttrsToList (k: v: "${k}=${v}") w.envVars)
              else [];
          in
            envTokens ++ (map toString w.command) ++ (lib.optional (w.separator != null) w.separator)
        )
        enabledPrefixes;
    in
      map lib.escapeShellArg launchPrefixTokens;
  }
