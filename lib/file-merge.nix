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
    fileMerge = rec {
      mkDirective = {
        action ? "force",
        value ? null,
      }:
        {
          __nixcraft_file_merge = "";
          inherit action;
        }
        // (lib.optionalAttrs (value != null) {inherit value;});

      force = value:
        mkDirective {
          action = "force";
          inherit value;
        };

      remove = mkDirective {action = "remove";};

      keep = value:
        mkDirective {
          action = "keep";
          inherit value;
        };

      append = value:
        mkDirective {
          action = "append";
          inherit value;
        };

      merge = value:
        mkDirective {
          action = "merge";
          inherit value;
        };

      isDirective = val:
        builtins.isAttrs val && val ? __nixcraft_file_merge;
    };
  }
