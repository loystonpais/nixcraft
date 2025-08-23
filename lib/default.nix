{lib, ...}: let
  inherit
    (builtins)
    readDir
    elem
    mapAttrs
    readFile
    fromJSON
    toJSON
    attrValues
    concatStringsSep
    dirOf
    toFile
    ;
  inherit
    (lib)
    mapAttrs'
    nameValuePair
    foldl'
    concatMapStringsSep
    filter
    getAttrs
    mkMerge
    foldAttrs
    ;

  sources = lib.nixcraft.importSources ../sources;
in rec {
  importSubmodules = dir: args: let
    dirContent = readDir'nixFiles dir;
    submodules = mapAttrs' (name: value: nameValuePair (removeNixSuffix name) (import (joinPathAndString dir name) (args // submodules))) dirContent;
  in
    submodules;

  importBuilders = dir: args: let
    dirContent = readDir'nixFiles dir;
    builders = mapAttrs' (name: value: nameValuePair (removeNixSuffix name) (import (joinPathAndString dir name) (args // builders))) dirContent;
  in
    builders;

  importSources = dir: let
    dirContent = readDir'files dir;
    sources = mapAttrs' (name: value:
      nameValuePair name (let
        filePath = joinPathAndString dir name;
        fileContent =
          if isJsonFile name
          then readJSON filePath
          else if isNixFile name
          then import filePath {inherit lib;}
          else readFile filePath;
      in
        fileContent))
    dirContent;
  in
    sources;

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

  removeNixSuffix = lib.strings.removeSuffix ".nix";

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
  };

  types = {
    minecraftVersion = lib.mkOptionType {
      name = "minecraftVersion";
      description = "Minecraft version";
      check = version:
        lib.assertMsg
        (elem version (versionManifestV2.getAllVersions (sources."version_manifest_v2.json")))
        "Minecraft version '${version}' does not exist.";
      merge = loc: defs: lib.head defs;
    };

    memorySize = lib.mkOptionType {
      name = "memorySize";
      description = "Memory size with units (e.g., '3GiB', '3000MiB', '4096KiB')";
      check = value: let
        pattern = "^([0-9]+)(KiB|MiB|GiB|TiB)$";
        matches = builtins.match pattern (toString value);
      in
        lib.assertMsg
        (lib.isString value && matches != null)
        "Invalid memory size: '${toString value}'. Use format like '3GiB', '3000MiB', or '4096KiB'.";
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
}
