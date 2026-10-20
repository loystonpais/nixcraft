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
    fromMinecraftOptionsTxt = text: let
      lines = lib.filter (l: l != "" && !lib.hasPrefix "#" l && lib.hasInfix ":" l) (lib.splitString "\n" text);
      parseLine = line: let
        parts = lib.splitString ":" line;
        key = lib.trim (builtins.head parts);
        val = lib.trim (lib.concatStringsSep ":" (builtins.tail parts));
      in {
        name = key;
        value = val;
      };
    in
      builtins.listToAttrs (map parseLine lines);
  }
