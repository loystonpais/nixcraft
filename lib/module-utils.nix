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
    modules = {
      # Crazy function
      # https://discourse.nixos.org/t/infinite-recursion-in-module-with-mkmerge/10989/13
      # https://gist.github.com/udf/4d9301bdc02ab38439fd64fbda06ea43
      mkMergeTopLevel = names: attrs:
        getAttrs names (
          mapAttrs (k: v: mkMerge v) (foldAttrs (n: a: [n] ++ a) [] attrs)
        );
    };
    manifest = {
      mkAssetHashPath = sha1: (builtins.substring 0 2 sha1) + "/" + sha1;
    };

    # source: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/config/shells-environment.nix#L14
  }
