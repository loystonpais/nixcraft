{lib, ...}: let
  sources = lib.nixcraft.importSources ./.;
in
  sources
  // {
    # Index: reverse lookup from Maven coordinate name to lock entry
    # Enables JOIN-style queries: given a library name, find its loader version info
    lockByName = builtins.listToAttrs (
      lib.mapAttrsToList (version: entry:
        lib.nameValuePair entry.name entry
      )
      sources.lock
    );
  }
