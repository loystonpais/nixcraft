{
  pkgs,
  fetchAssetFromHash,
  fetchSha1,
  mkLibDir,
  lib,
  ...
}: {jar}: let
  inherit (lib) escapeShellArg;
  inherit (lib.nixcraft) readJSON;
  inherit (lib.nixcraft.filesystem) listJarFilesRecursive;

  esc = escapeShellArg;
  removeQuotes = str: lib.removePrefix "'" (lib.removeSuffix "'" str);

  unpacked =
    pkgs.runCommand "forge-installer-unpacked" {
      buildInputs = [pkgs.unzip];
    } ''
      mkdir -p $out
      cd $out
      unzip ${jar}
    '';

  versionJson = readJSON "${unpacked}/version.json";
  installProfileJson = readJSON "${unpacked}/install_profile.json";

  mcVersion = versionJson.inheritsFrom;
  versionId = versionJson.id;

  mainClass = versionId.mainClass;

  versionLibraries = versionJson.libraries;
  installProfileLibraries = installProfileJson.libraries;

  mojmapsExists = installProfileJson.data ? MOJMAPS_SHA;

  clientMojmapsSha1 = removeQuotes installProfileJson.data.MOJMAPS_SHA.client;
  serverMojmapsSha1 = removeQuotes installProfileJson.data.MOJMAPS_SHA.server;

  allLibraries = versionJson.libraries ++ installProfileJson.libraries;

  allLibrariesDir = mkLibDir {
    libraries = allLibraries;
  };

  librariesString = lib.concatStringsSep ":" (listJarFilesRecursive allLibrariesDir);

  fetchMojmaps = side: sha1:
    pkgs.runCommand "forge-mojmaps" {
      buildInputs = [pkgs.jdk];
      outputHashAlgo = "sha1";
      outputHash = sha1;
    } ''
      java -cp ${esc librariesString} \
        net.minecraftforge.installertools.ConsoleTool \
        --task DOWNLOAD_MOJMAPS \
        --sanitize \
        --version ${esc mcVersion} \
        --side ${esc side} \
        --output $out
    '';

  clientMojmaps =
    fetchMojmaps "client" clientMojmapsSha1;

  serverMojmaps =
    fetchMojmaps "server" serverMojmapsSha1;

  installDir = mode: clientJar: let
    mojmaps = fetchMojmaps mode clientMojmapsSha1;
  in
    pkgs.runCommand "forge-install-dir" {
      buildInputs = [pkgs.jdk];
    }
    ''
      mkdir -p $out
      cp -a ${allLibrariesDir} $out/libraries
      chmod u+w -R $out/libraries

      ${lib.optionalString mojmapsExists ''
        mkdir -p $out/libraries/net/minecraft/${mode}/${esc mcVersion}
        ln -s ${mojmaps} $out/libraries/net/minecraft/${mode}/${esc mcVersion}/${mode}-${esc mcVersion}-mappings.tsrg
      ''}

      ${
        if mode == "client"
        then ''
          mkdir -p $out
          echo "{}" > $out/launcher_profiles.json
          mkdir -p $out/versions/${esc mcVersion}
          ln -s ${esc clientJar} $out/versions/${esc mcVersion}/${esc mcVersion}.jar

          java -jar ${esc jar} --installClient $out --offline
        ''
        else ''
          java -jar ${esc jar} --installServer $out --offline
        ''
      }
    '';

  clientInstallDirWithClientJar = installDir "client";
  serverInstallDir = installDir "server" null;
in {
  inherit
    unpacked
    versionJson
    installProfileJson
    versionLibraries
    installProfileLibraries
    versionId
    mcVersion
    mainClass
    clientMojmaps
    serverMojmaps
    clientInstallDirWithClientJar
    serverInstallDir
    ;
}
