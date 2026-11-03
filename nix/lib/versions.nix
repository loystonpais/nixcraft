{
  config,
  lib,
  ...
}: let
  inherit (config.nixcraft) sources;
in {
  nixcraft.lib.versions = rec {
    compare = v1: v2: builtins.compareVersions v1 v2;
    eq = v1: v2: (compare v1 v2) == 0;
    neq = v1: v2: (compare v1 v2) != 0;
    gr = v1: v2: (compare v1 v2) == 1;
    ls = v1: v2: (compare v1 v2) == -1;
    grEq = v1: v2: gr v1 v2 || eq v1 v2;
    lsEq = v1: v2: ls v1 v2 || eq v1 v2;

    min = v1: v2: if ls v1 v2 then v1 else v2;
    max = v1: v2: if gr v1 v2 then v1 else v2;

    sort = list: lib.sort (a: b: gr a b) list;
    sortAsc = list: lib.sort (a: b: ls a b) list;
    sortDesc = list: sort list;

    list = rec {
      indexOf = list: version:
        lib.lists.findFirstIndex (x: x == version) (-1) list;

      has = list: version: (indexOf list version) != -1;

      stepVersion = list: n: current: let
        idx = indexOf list current;
        len = builtins.length list;
        targetIdx = idx + n;
      in
        if idx == -1 then null
        else if targetIdx < 0 || targetIdx >= len then null
        else builtins.elemAt list targetIdx;

      stepOlder = list: n: stepVersion list n;
      stepNewer = list: n: stepVersion list (-n);

      olderVersion = list: stepOlder list 1;
      newerVersion = list: stepNewer list 1;

      nextVersion = list: newerVersion list;
      prevVersion = list: olderVersion list;
      nextVersionN = list: n: stepNewer list n;
      prevVersionN = list: n: stepOlder list n;
    };

    semver = rec {
      inherit compare eq neq gr ls grEq lsEq min max sort sortAsc sortDesc;

      bumpUp = list: target: let
        matches = builtins.filter (v: grEq v target) list;
      in
        if list == [] then null
        else if matches != [] then lib.last matches
        else builtins.head list;

      bumpDown = list: target: let
        matches = builtins.filter (v: lsEq v target) list;
      in
        if list == [] then null
        else if matches != [] then builtins.head matches
        else lib.last list;

      closest = {
        list,
        target,
        direction ? "up",
      }:
        if list == [] then null
        else if builtins.elem target list then target
        else if direction == "up" then bumpUp list target
        else if direction == "down" then bumpDown list target
        else throw "Unknown direction '${direction}'; expected 'up' or 'down'";
    };

    inherit (list)
      indexOf
      has
      stepVersion
      stepOlder
      stepNewer
      olderVersion
      newerVersion
      nextVersion
      prevVersion
      nextVersionN
      prevVersionN;

    inherit (semver)
      bumpUp
      bumpDown
      closest;
  };

  nixcraft.lib.minecraftVersion = rec {
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

  nixcraft.lib.versionManifestV2 = {
    getAllVersions = manifest: map (attr: attr.id) manifest.versions;
  };
}
