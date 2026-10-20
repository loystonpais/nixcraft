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
    forgeLike = rec {
      # Keep only the loader specific arguments of a launcher `minecraftArguments` string,
      # i.e. drop every `--flag ${placeholder}` pair that the instance fills in itself.
      parseLoaderArguments = str: let
        isFlag = lib.hasPrefix "--";
        isPlaceholder = lib.hasInfix "\${";
        go = acc: tokens:
          if tokens == []
          then acc
          else let
            head = builtins.head tokens;
            rest = builtins.tail tokens;
          in
            if isFlag head && rest != [] && !(isFlag (builtins.head rest))
            then
              go
              (acc ++ lib.optionals (!isPlaceholder (builtins.head rest)) [head (builtins.head rest)])
              (builtins.tail rest)
            else go (acc ++ lib.optional (!isPlaceholder head) head) rest;
      in
        go [] (lib.filter (s: s != "") (lib.splitString " " str));
    };
  }
