{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.nixcraft) readJSON;
  inherit (pkgs) runCommand unzip;
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
  in {
    inherit index;
    inherit (index) name versionId formatVersion;
    minecraftVersion = minecraftVersion;
    inherit fabricLoaderVersion;
    __toString = self: self.src;
    src = unpacked;
  }
