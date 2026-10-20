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
  }
