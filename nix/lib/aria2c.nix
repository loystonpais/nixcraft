{lib, ...}: {
  nixcraft.lib.aria2c = rec {
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
