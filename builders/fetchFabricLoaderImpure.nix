{
  lib,
  pkgs,
  ...
}: let
  fabricInstaller = builtins.fetchurl {
    url = "https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.3/fabric-installer-1.0.3.jar";
    sha256 = "sha256:0zxhfk933wpxs0qyfnw33276lw5s7g4zqhr17ymbfagq3smq5aiq";
  };

  inherit (lib) escapeShellArg;
in
  {
    mcVersion,
    loaderVersion,
    hash,
    client ? true,
    server ? false,
    jre ? pkgs.jre,
    runCommand ? pkgs.runCommand,
  }: let
    mode =
      if server == client
      then throw "client and server cannot be ${client} at the same time. Either one needs to be true"
      else if client
      then "client"
      else "server";
  in
    runCommand "fabric-loader-mc${mcVersion}-v${loaderVersion}" {
      buildInputs = [jre];
      outputHashMode = "recursive";
      outputHash = hash;
    } ''
      mkdir -p $out
      java -jar ${fabricInstaller} ${mode} \
        -dir $out \
        -mcversion ${escapeShellArg mcVersion} \
        -loader ${escapeShellArg loaderVersion} \
        -noprofile
      rm -rf $out/versions
      rm -rf $out/fabric-server-launch.jar
    ''
