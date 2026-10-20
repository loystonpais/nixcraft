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
    isPythonFile = hasExtension "py";
    isShellFile = file: hasExtension "sh" file || hasExtension "bash" file;
    removePythonExt = lib.strings.removeSuffix ".py";
    removeShellExt = file:
      if hasExtension "sh" file
      then lib.strings.removeSuffix ".sh" file
      else lib.strings.removeSuffix ".bash" file;
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
    portFromString = string: let
      hash = builtins.hashString "md5" string;
      part = builtins.substring 0 15 hash;
      num = (builtins.fromTOML "v=0x${part}").v;
      port = (lib.mod num 16384) + 49152;
    in
      port;
    filesystem = {
      listJarFilesRecursive = drv: filter (path: isJarFile (toString path)) (lib.filesystem.listFilesRecursive drv);

      listDirs = path: mapAttrsToList (name: _: joinPathAndString path name) (readDir'dirs path);
      listFiles = path: mapAttrsToList (name: _: joinPathAndString path name) (readDir'files path);
      listAll = path: mapAttrsToList (name: _: joinPathAndString path name) (readDir path);
    };
    lists = {
      max = list: lib.foldl' lib.max (builtins.head list) list;
      min = list: lib.foldl' lib.min (builtins.head list) list;
    };
  }
