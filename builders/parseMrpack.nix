{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.nixcraft) readJSON;
  inherit (pkgs) runCommand unzip;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib) removePrefix;
  inherit (builtins) listToAttrs unsafeDiscardStringContext;
in
  src: let
    # Some zips have weird permissions,
    # so we need to fix them
    unpacked =
      runCommand "mrpack-unpacked" {
        buildInputs = [unzip];
      } ''
        unzip "${src}" -d $out
        find $out -type d -exec chmod 755 {} \;
        find $out -type f -exec chmod 644 {} \;

        mkdir -p $out/overrides
        mkdir -p $out/client-overrides
        mkdir -p $out/server-overrides
      '';

    index = readJSON "${unpacked}/modrinth.index.json";

    minecraftVersion = index.dependencies.minecraft;

    fabricLoaderVersion =
      if index.dependencies ? "fabric-loader"
      then index.dependencies.fabric-loader
      else null;

    overrides = listToAttrs (
      map
      (path: {
        name = unsafeDiscardStringContext (removePrefix "${unpacked}/overrides/" path);
        value = path;
      }) (listFilesRecursive "${unpacked}/overrides")
    );

    client-overrides = listToAttrs (
      map (path: {
        name = unsafeDiscardStringContext (removePrefix "${unpacked}/client-overrides/" path);
        value = path;
      }) (listFilesRecursive "${unpacked}/client-overrides")
    );

    server-overrides = listToAttrs (
      map (path: {
        name = unsafeDiscardStringContext (removePrefix "${unpacked}/server-overrides/" path);
        value = path;
      }) (listFilesRecursive "${unpacked}/server-overrides")
    );

    overrides-plus-client-overrides = overrides // client-overrides;
    overrides-plus-server-overrides = overrides // server-overrides;
  in {
    inherit
      index
      overrides
      client-overrides
      server-overrides
      overrides-plus-client-overrides
      overrides-plus-server-overrides
      fabricLoaderVersion
      ;
    inherit (index) name versionId formatVersion;
    minecraftVersion = minecraftVersion;
    __toString = self: self.src;
    src = unpacked;
  }
