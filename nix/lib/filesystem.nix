{lib, ...}: let
  inherit (builtins) fromJSON readFile readDir;
in {
  nixcraft.lib = rec {
    forAllSystems = lib.genAttrs lib.systems.flakeExposed;

    filterAttrs = lib.attrsets.filterAttrs;

    filterAttrsByValue = f: attrs: filterAttrs (n: v: f v) attrs;

    filterAttrsByName = f: attrs: filterAttrs (n: v: f n) attrs;

    filterDirs = filterAttrsByValue (v: v == "directory");

    filterFiles = filterAttrsByValue (v: v == "regular");

    hasExtension = extension: lib.strings.hasSuffix (".${extension}");

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

    readDir'dirs = path: filterDirs (readDir path);

    readDir'files = path: filterFiles (readDir path);

    readDir'nixFiles = path:
      filterAttrsByName (file: isNixFile file) (readDir'files path);

    joinPathAndString = path: string: "${path}/${string}";

    readJSON = path: fromJSON (readFile path);

    portFromString = string: let
      hash = builtins.hashString "md5" string;
      part = builtins.substring 0 15 hash;
      num = (builtins.fromTOML "v=0x${part}").v;
    in
      (lib.mod num 16384) + 49152;

    filesystem = {
      listJarFilesRecursive = drv:
        builtins.filter (path: isJarFile (toString path)) (lib.filesystem.listFilesRecursive drv);

      listDirs = path:
        lib.mapAttrsToList (name: _: joinPathAndString path name) (readDir'dirs path);

      listFiles = path:
        lib.mapAttrsToList (name: _: joinPathAndString path name) (readDir'files path);

      listAll = path:
        lib.mapAttrsToList (name: _: joinPathAndString path name) (readDir path);
    };

    lists = {
      max = list: lib.foldl' lib.max (builtins.head list) list;
      min = list: lib.foldl' lib.min (builtins.head list) list;
    };
  };
}
