{
  pkgs,
  lib,
  ...
}: {
  name,
  hash,
  entries,
  inputFile ? builtins.toFile "${name}-inputfile" (lib.nixcraft.aria2c.mkInputEntries entries),
  maxConcurrentDownloads ? 5,
  extraArgs ? [],
}:
pkgs.runCommand name {
  nativeBuildInputs = [pkgs.aria2];
  outputHashMode = "recursive";
  outputHash = hash;
}
''
  mkdir -p $out
  cd $out
  aria2c \
    --input-file ${inputFile} \
    --max-concurrent-downloads=${builtins.toString maxConcurrentDownloads} \
    --human-readable=true ${lib.concatStringsSep " " extraArgs}
''
