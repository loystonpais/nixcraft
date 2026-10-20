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
    importSubmodules = dir: args: let
      dirContent = readDir'nixFiles dir;
      moduleName = name: let
        baseName = removeNixExt name;
      in
        if lib.strings.hasSuffix "Module" baseName
        then baseName
        else "${baseName}Module";
      submodules = mapAttrs' (name: value: nameValuePair (moduleName name) (import (joinPathAndString dir name) (args // submodules))) dirContent;
    in
      submodules;

    importBuilders = dir: args: let
      dirContent = readDir'nixFiles dir;
      builders = mapAttrs' (name: value: nameValuePair (removeNixExt name) (import (joinPathAndString dir name) (args // builders))) dirContent;
    in
      builders;

    importPackages = dir: pkgs: args: let
      fullArgs = {inherit lib;} // args;
      nixFiles = readDir'nixFiles dir;
      packages'nixfiles =
        mapAttrs'
        (name: value: nameValuePair (removeNixExt name) (pkgs.callPackage (joinPathAndString dir name) fullArgs))
        nixFiles;

      subdirs = readDir'dirs dir;
      packages'subdir =
        mapAttrs'
        (name: value: nameValuePair name (pkgs.callPackage (joinPathAndString dir name) fullArgs))
        subdirs;

      pacakges = packages'nixfiles // packages'subdir;
    in
      pacakges;

    importScripts = dir: pkgs: let
      files = filterAttrsByName (name: !(lib.strings.hasPrefix "." name)) (readDir'files dir);
    in
      mapAttrs' (
        fileName: _: let
          scriptName =
            if isPythonFile fileName
            then removePythonExt fileName
            else if isShellFile fileName
            then removeShellExt fileName
            else fileName;
          binName = "nixcraft-${scriptName}";
          filePath = joinPathAndString dir fileName;
          pkg =
            if isPythonFile fileName
            then
              pkgs.writers.writePython3Bin binName {
                doCheck = false;
              } (readFile filePath)
            else pkgs.writeShellScriptBin binName (readFile filePath);
        in
          nameValuePair scriptName pkg
      )
      files;

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
  }
