{lib, ...}: {
  nixcraft.lib.fileMerge = rec {
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

    isDirective = value:
      builtins.isAttrs value && (value ? __nixcraft_file_merge);

    stripDirectives = value:
      if isDirective value
      then
        if value.action == "remove"
        then null
        else if value ? value
        then stripDirectives value.value
        else null
      else if builtins.isAttrs value
      then
        lib.filterAttrs (_: v: v != null)
        (lib.mapAttrs (_: stripDirectives) value)
      else if builtins.isList value
      then
        builtins.filter (v: v != null)
        (map stripDirectives value)
      else value;
  };
}
