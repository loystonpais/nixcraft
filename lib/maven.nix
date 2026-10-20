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
    maven = rec {
      mkLibPath = libString: let
        atParts = lib.splitString "@" libString;
        baseCoord = builtins.elemAt atParts 0;
        ext =
          if builtins.length atParts > 1
          then builtins.elemAt atParts 1
          else "jar";
        parts = lib.splitString ":" baseCoord;
        group = builtins.elemAt parts 0;
        artifact = builtins.elemAt parts 1;
        version = builtins.elemAt parts 2;
        classifier =
          if builtins.length parts > 3
          then builtins.elemAt parts 3
          else null;
        groupPath = builtins.replaceStrings ["."] ["/"] group;
        fileName = "${artifact}-${version}${
          if classifier != null
          then "-${classifier}"
          else ""
        }.${ext}";
      in "${groupPath}/${artifact}/${version}/${fileName}";

      mkLibUrl = url: libString: "${url}/${mkLibPath libString}";

      isLibraryAllowedForOS = OS: library: let
        lemma1 = acc: rule:
          if rule.action == "allow"
          then
            if rule ? os
            then rule.os.name == OS
            else true
          else if rule ? os
          then rule.os.name != OS
          else false;
      in
        if library ? rules
        then foldl' lemma1 false library.rules
        else true;

      filterLibrariesByOS = OS: libraries: filter (isLibraryAllowedForOS OS) libraries;

      filterClassifiers = library: lib.filter (x: !(x.downloads ? "classifiers")) library;

      filterEmptyArtifactUrl = lib.filter (x: !(x.downloads.artifact.url == ""));

      librariesByName = libraries:
        lib.listToAttrs (map (library: nameValuePair library.name library) libraries);

      toLibraryArtifactLinkTree = fetcher: libraries:
        lib.mapAttrs' (
          name: library:
            nameValuePair
            library.downloads.artifact.path (fetcher library.downloads.artifact)
        ) (librariesByName libraries);

      getPlatformInfo = hostPlatform: let
        system = hostPlatform.system;
      in {
        inherit system;
        isArm64 = hostPlatform.isAarch64 or (lib.hasPrefix "aarch64" system);
        isX86 = hostPlatform.isx86_64 or (lib.hasPrefix "x86_64" system);
        isDarwin = hostPlatform.isDarwin or (lib.hasSuffix "darwin" system);
        isLinux = hostPlatform.isLinux or (lib.hasSuffix "linux" system);
        isWindows = hostPlatform.isWindows or (lib.hasSuffix "windows" system);
      };

      isOsRuleMatching = p: osRule: let
        name = osRule.name or null;
        arch = osRule.arch or null;
      in
        (
          if name == null
          then true
          else if name == "osx"
          then p.isDarwin
          else if name == "osx-arm64"
          then p.isDarwin && p.isArm64
          else if name == "linux"
          then p.isLinux
          else if name == "linux-arm64"
          then p.isLinux && p.isArm64
          else if name == "windows"
          then p.isWindows
          else if name == "windows-arm64"
          then p.isWindows && p.isArm64
          else if name == "windows-x86"
          then p.isWindows && p.isX86
          else false
        )
        && (
          if arch == null
          then true
          else if arch == "arm64" || arch == "aarch64"
          then p.isArm64
          else if arch == "x86" || arch == "x86_64" || arch == "amd64"
          then p.isX86
          else false
        );

      isOsAllowed = p: rules:
        if rules == []
        then true
        else
          builtins.foldl' (
            current: rule: let
              ruleApplies = !(rule ? os) || (isOsRuleMatching p rule.os);
            in
              if ruleApplies
              then rule.action == "allow"
              else current
          )
          false
          rules;

      isNativeArchAllowed = p: name: let
        hasArm64 = lib.hasInfix "arm64" name;
        hasArm32 = lib.hasInfix "arm32" name;
      in
        if !lib.hasInfix "natives-" name
        then true
        else if p.isArm64
        then hasArm64
        else if p.isX86
        then !hasArm64 && !hasArm32
        else true;

      isClassifierAllowed = p: cName: hasArm64Classifier: let
        hasArm64 = lib.hasInfix "arm64" cName;
        matchesOs =
          if p.isDarwin
          then lib.hasInfix "macos" cName || lib.hasInfix "osx" cName
          else if p.isLinux
          then lib.hasInfix "linux" cName
          else if p.isWindows
          then lib.hasInfix "windows" cName
          else false;
      in
        matchesOs
        && (
          if p.isArm64
          then
            (
              if hasArm64Classifier
              then hasArm64
              else true
            )
          else !hasArm64
        );

      mkNormalizedMinecraftLibraryAttrs = hostPlatform: pkgs: libraries: let
        p = getPlatformInfo hostPlatform;
        fetchLib = libInfo:
          pkgs.fetchurl {
            inherit (libInfo) url hash;
          };

        rawLibrariesList =
          if builtins.isAttrs libraries
          then lib.mapAttrsToList (name: libDef: libDef // {inherit name;}) libraries
          else libraries;
      in
        builtins.foldl' (
          acc: raw:
            if raw ? relativePath && raw ? jar
            then
              acc
              // {
                ${raw.name} = {
                  enable = raw.enable or true;
                  native = raw.native or false;
                  relativePath = raw.relativePath;
                  jar = raw.jar;
                };
              }
            else let
              allowed = (isOsAllowed p (raw.rules or [])) && (isNativeArchAllowed p raw.name);

              libInfo = sources.libraries.${raw.name} or null;
              isNative =
                (raw.native or false)
                || (raw ? extract)
                || (lib.hasInfix "natives" raw.name)
                || (lib.hasInfix "linux-" raw.name)
                || (lib.hasInfix "osx-" raw.name)
                || (lib.hasInfix "windows-" raw.name);

              entry =
                if libInfo != null
                then {
                  ${raw.name} = {
                    enable = allowed;
                    native = isNative;
                    relativePath = mkLibPath raw.name;
                    jar = fetchLib libInfo;
                  };
                }
                else {};
            in
              acc // entry
        ) {}
        rawLibrariesList;

      parseMavenCoord = coord: let
        parts = lib.splitString ":" coord;
        group = builtins.elemAt parts 0;
        artifact = builtins.elemAt parts 1;
        version =
          if builtins.length parts >= 3
          then builtins.elemAt parts 2
          else null;
        classifier =
          if builtins.length parts >= 4
          then builtins.elemAt parts 3
          else null;
      in {
        inherit group artifact version classifier;
        coordKey = "${group}:${artifact}${
          if classifier != null
          then ":${classifier}"
          else ""
        }";
      };

      dedupeNormalizedLibraryAttrs = {
        libraries,
        priorityLibraries ? {},
      }: let
        # 1. Coordinate keys from priority libraries (e.g. loader libraries)
        prioKeys = lib.listToAttrs (map (
          name: let
            parsed = parseMavenCoord name;
          in
            lib.nameValuePair parsed.coordKey name
        ) (builtins.attrNames priorityLibraries));

        # 2. Group enabled libraries by coordKey to compare versions if needed
        grouped = lib.foldl' (
          acc: name: let
            parsed = parseMavenCoord name;
            libDef = libraries.${name};
          in
            if !(libDef.enable or true)
            then acc
            else let
              key = parsed.coordKey;
              current = acc.${key} or [];
            in
              acc
              // {
                ${key} =
                  current
                  ++ [
                    {
                      inherit name;
                      version = parsed.version;
                    }
                  ];
              }
        ) {} (builtins.attrNames libraries);

        # Determine which library wins for each coordKey
        winningNames =
          lib.mapAttrs (
            key: items:
              if prioKeys ? ${key}
              then prioKeys.${key}
              else
                (lib.foldl' (
                    best: curr:
                      if best == null
                      then curr
                      else if curr.version != null && best.version != null && (builtins.compareVersions curr.version best.version) > 0
                      then curr
                      else best
                  )
                  null
                  items).name
          )
          grouped;

        winningSet = lib.listToAttrs (map (name: lib.nameValuePair name true) (builtins.attrValues winningNames));
      in
        lib.mapAttrs (
          name: libDef: let
            parsed = parseMavenCoord name;
            key = parsed.coordKey;
            hasCollision = (builtins.length (grouped.${key} or [])) > 1 || (prioKeys ? ${key} && prioKeys.${key} != name);
          in
            if hasCollision && !(winningSet ? ${name})
            then libDef // {enable = false;}
            else libDef
        )
        libraries;
    };
  }
