{lib, ...}: let
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
    ;

  sources = lib.nixcraft.importSources ../sources;
in rec {
  importSubmodules = dir: args: let
    dirContent = readDir'nixFiles dir;
    submodules = mapAttrs' (name: value: nameValuePair (removeNixExt name) (import (joinPathAndString dir name) (args // submodules))) dirContent;
  in
    submodules;

  importBuilders = dir: args: let
    dirContent = readDir'nixFiles dir;
    builders = mapAttrs' (name: value: nameValuePair (removeNixExt name) (import (joinPathAndString dir name) (args // builders))) dirContent;
  in
    builders;

  importPackages = dir: pkgs: args: let
    nixFiles = readDir'nixFiles dir;
    packages'nixfiles =
      mapAttrs'
      (name: value: nameValuePair (removeNixExt name) (pkgs.callPackage (joinPathAndString dir name) args))
      nixFiles;

    subdirs = readDir'dirs dir;
    packages'subdir =
      mapAttrs'
      (name: value: nameValuePair name (pkgs.callPackage (joinPathAndString dir name) args))
      subdirs;

    pacakges = packages'nixfiles // packages'subdir;
  in
    pacakges;

  importSources = dir: let
    dirFiles = readDir'files dir;
    sources = mapAttrs' (name: value:
      nameValuePair (
        if isJsonFile name
        then removeJsonExt name
        else if isNixFile name
        then removeNixExt name
        else name
      ) (let
        filePath = joinPathAndString dir name;
        fileContent =
          if isJsonFile name
          then readJSON filePath
          else if isNixFile name
          then import filePath {inherit lib;}
          else readFile filePath;
      in
        fileContent))
    dirFiles;

    dirDirs = readDir'dirs dir;
    sources'subdir =
      mapAttrs' (
        name: value:
          nameValuePair
          name
          (
            let
              subDirPath = joinPathAndString dir name;
            in
              import subDirPath {inherit lib;}
          )
      )
      dirDirs;
  in
    sources // sources'subdir;

  forAllSystems = lib.genAttrs lib.systems.flakeExposed;

  filterAttrs = lib.attrsets.filterAttrs;

  filterAttrsByValue = f: attrs: filterAttrs (n: v: f v) attrs;

  filterAttrsByName = f: attrs: filterAttrs (n: v: f n) attrs;

  # Returns attrs whose value is "directory"
  filterDirs = filterAttrsByValue (v: v == "directory");

  # Returns attrs whose value is "regular"
  filterFiles = filterAttrsByValue (v: v == "regular");

  hasExtension = extension: lib.strings.hasSuffix ("." + extension);

  isNixFile = hasExtension "nix";

  isJsonFile = hasExtension "json";

  isJarFile = hasExtension "jar";

  isYamlFile = file: hasExtension "yaml" file || hasExtension "yml" file;

  removeNixExt = lib.strings.removeSuffix ".nix";

  removeJsonExt = lib.strings.removeSuffix ".json";

  isDefaultNixFile = s: s == "default.nix";

  # Like readDir but only returns dirs
  readDir'dirs = path: filterDirs (readDir path);

  # Like readDir but only returns files
  readDir'files = path: filterFiles (readDir path);

  # Like readDir'files but only returns nix files
  readDir'nixFiles = path:
    filterAttrsByName (file: isNixFile file) (readDir'files path);

  joinPathAndString = path: string: path + "/${string}";

  readJSON = path: fromJSON (readFile path);

  filesystem = {
    listJarFilesRecursive = drv: filter (path: isJarFile (toString path)) (lib.filesystem.listFilesRecursive drv);
  };

  lists = {
    max = list: lib.foldl' lib.max (builtins.head list) list;
    min = list: lib.foldl' lib.min (builtins.head list) list;
  };

  toMinecraftServerProperties = attrs:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        key: value: "${key}=${
          if lib.isBool value
          then
            (
              if value
              then "true"
              else "false"
            )
          else if builtins.isNull value
          then ""
          else toString value
        }"
      )
      attrs
    );

  toMinecraftOptionsTxt = attrs:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        key: value: "${key}:${
          if lib.isBool value
          then
            (
              if value
              then "true"
              else "false"
            )
          else toString value
        }"
      )
      (lib.filterAttrs (n: v: v != null) attrs)
    );

  modules = {
    # Crazy function
    # https://discourse.nixos.org/t/infinite-recursion-in-module-with-mkmerge/10989/13
    # https://gist.github.com/udf/4d9301bdc02ab38439fd64fbda06ea43
    mkMergeTopLevel = names: attrs:
      getAttrs names (
        mapAttrs (k: v: mkMerge v) (foldAttrs (n: a: [n] ++ a) [] attrs)
      );
  };

  manifest = rec {
    mkAssetHashPath = sha1: (builtins.substring 0 2 sha1) + "/" + sha1;

    isArtifactAllowed = OS: artifact: let
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
      if artifact ? rules
      then foldl' lemma1 false artifact.rules
      else true;

    filterArtifacts = OS: artifacts: filter (isArtifactAllowed OS) artifacts;
  };

  # source: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/config/shells-environment.nix#L14
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

  options = {
    # source https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/config/shells-environment.nix#L39
    envVars = lib.mkOption {
      example = {
        FOO = "BAR";
      };
      type = with lib.types;
        attrsOf (
          nullOr (oneOf [
            (listOf (oneOf [
              int
              str
              path
            ]))
            int
            str
            path
          ])
        );
      apply = let
        toStr = v:
          if lib.isPath v
          then "${v}"
          else toString v;
      in
        attrs:
          lib.mapAttrs (n: v:
            if lib.isList v
            then lib.concatMapStringsSep ":" toStr v
            else toStr v) (
            lib.filterAttrs (n: v: v != null) attrs
          );
    };

    minecraftVersionDyn = lib.mkOption {
      type = with lib.types; either (enum ["latest-release" "latest-snapshot"]) types.minecraftVersion;
      description = "Minecraft version, or one of: latest-release, latest-snapshot";

      apply = version:
        if version == "latest-release"
        then sources.version_manifest_v2.latest.release
        else if version == "latest-snapshot"
        then sources.version_manifest_v2.latest.snapshot
        else version;
    };
  };

  minecraftVersion = rec {
    compare = v1: v2: let
      versionList = sources.normalized-manifest.versionListOrdered;
      index1 = lib.lists.findFirstIndex (x: x == v1) (-1) versionList;
      index2 = lib.lists.findFirstIndex (x: x == v2) (-1) versionList;
    in
      if index1 == -1 || index2 == -1
      then throw "Invalid minecraft versions '${v1}' or '${v2}'"
      else lib.compare index1 index2;

    eq = v1: v2: (compare v1 v2) == 0;
    gr = v1: v2: (compare v1 v2) == -1;
    ls = v1: v2: (compare v1 v2) == 1;

    grEq = v1: v2: gr v1 v2 || eq v1 v2;
    lsEq = v1: v2: ls v1 v2 || eq v1 v2;
  };

  types = {
    minecraftVersion = lib.mkOptionType {
      name = "minecraftVersion";
      description = "Minecraft version";
      check = version:
        lib.assertMsg
        (elem version (versionManifestV2.getAllVersions (sources.version_manifest_v2)))
        "Minecraft version '${version}' does not exist.";
      merge = loc: defs: (lib.head defs).value;
    };

    javaMemorySize = lib.mkOptionType {
      name = "javaMemorySize";
      description = "Java memory size (in MBs)";
      check = value:
        lib.assertMsg (builtins.isInt value && (value >= 512))
        "Invalid memory size: '${toString value}'. Must be an integer and above 512MBs.";
      merge = loc: defs: (lib.head defs).value;
    };
  };

  versionManifestV2 = {
    getAllVersions = manifest: map (attr: attr.id) manifest.versions;
  };

  aria2c = rec {
    mkInputEntry = {
      urls,
      out ? null,
      dir ? null,
      headers ? [],
    }: ''
      ${lib.concatStringsSep " " urls}
        ${lib.optionalString (out != null) "out=${out}"}
        ${lib.optionalString (dir != null) "dir=${dir}"}
        ${lib.optionalString (headers != null) (lib.concatMapStringsSep " " (header: "headers=${header}") headers)}
    '';

    mkInputEntries = entries: lib.concatMapStringsSep "\n" (entry: mkInputEntry entry) entries;
  };

  maven = {
    mkLibUrl = url: libString: let
      inherit (lib) splitString replaceString;
      inherit (builtins) elemAt;
      libStringParts = splitString ":" libString;
      dotDir = elemAt libStringParts 0;
      dir = replaceString "." "/" dotDir;
      name = elemAt libStringParts 1;
      version = elemAt libStringParts 2;
    in "${url}/${dir}/${name}/${version}/${name}-${version}.jar";
  };
}
