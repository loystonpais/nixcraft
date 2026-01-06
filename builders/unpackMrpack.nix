{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs) runCommandLocal unzip;
  inherit (lib) escapeShellArg;
in
  {
    src,
    postUnpack ? "",
  }:
  # Some zips have weird permissions,
  # so we need to fix them
    runCommandLocal "mrpack-unpacked" {
      nativeBuildInputs = [unzip];
    } ''
      unzip ${escapeShellArg src} -d $out
      find $out -type d -exec chmod 755 {} \;
      find $out -type f -exec chmod 644 {} \;

      mkdir -p $out/overrides
      mkdir -p $out/client-overrides
      mkdir -p $out/server-overrides

      ${postUnpack}
    ''
