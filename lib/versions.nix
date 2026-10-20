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
    minecraftVersion = rec {
      compare = v1: v2: let
        versionList = sources.mojang.meta.versions;
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

    versionManifestV2 = {
      getAllVersions = manifest: map (attr: attr.id) manifest.versions;
    };
  }
