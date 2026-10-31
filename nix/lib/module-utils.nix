{lib, ...}: {
  nixcraft.lib.modules = {
    # https://discourse.nixos.org/t/infinite-recursion-in-module-with-mkmerge/10989/13
    # https://gist.github.com/udf/4d9301bdc02ab38439fd64fbda06ea43
    mkMergeTopLevel = names: attrs:
      lib.getAttrs names (
        lib.mapAttrs (k: v: lib.mkMerge v) (lib.foldAttrs (n: a: [n] ++ a) [] attrs)
      );
  };
  nixcraft.lib.manifest = {
    mkAssetHashPath = sha1: (builtins.substring 0 2 sha1) + "/" + sha1;
  };
}
