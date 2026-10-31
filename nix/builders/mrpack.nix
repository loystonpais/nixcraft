{config, ...}: {
  nixcraft.lib.builders = {
    unpackMrpack = pkgs: {
      src,
      postUnpack ? "",
    }:
      # Some zips have weird permissions, so we need to fix them
      pkgs.runCommandLocal "mrpack-unpacked" {
        nativeBuildInputs = [pkgs.unzip];
      } ''
        unzip ${pkgs.lib.escapeShellArg src} -d $out
        find $out -type d -exec chmod 755 {} \;
        find $out -type f -exec chmod 644 {} \;

        mkdir -p $out/overrides
        mkdir -p $out/client-overrides
        mkdir -p $out/server-overrides

        ${postUnpack}
      '';

    parseMrpack = pkgs: {unpacked}: let
      inherit (config.nixcraft.lib) readJSON;
      inherit (config.nixcraft.lib.filesystem) listDirs;
      inherit (pkgs.lib.filesystem) listFilesRecursive;
      inherit (pkgs.lib) removePrefix pathIsDirectory filterAttrs hasPrefix;
      inherit (builtins) listToAttrs unsafeDiscardStringContext;

      index = readJSON "${unpacked}/modrinth.index.json";

      minecraftVersion = index.dependencies.minecraft;
      fabricLoaderVersion = index.dependencies.fabric-loader or null;
      quiltLoaderVersion = index.dependencies.quilt-loader or null;
      forgeLoaderVersion = index.dependencies.forge or null;
      neoforgeLoaderVersion = index.dependencies.neoforge or null;

      dirs = rec {
        overrides = "${unpacked}/overrides";
        overrides-saves = "${overrides}/saves";
        overrides-world = "${overrides}/world";

        client-overrides = "${unpacked}/client-overrides";
        client-overrides-saves = "${client-overrides}/saves";

        server-overrides = "${unpacked}/server-overrides";
        server-overrides-world = "${server-overrides}/world";
      };

      allFileMap = rec {
        overrides = listToAttrs (
          map
          (path: {
            name = unsafeDiscardStringContext (removePrefix "${dirs.overrides}/" path);
            value = path;
          }) (listFilesRecursive dirs.overrides)
        );

        client-overrides = listToAttrs (
          map (path: {
            name = unsafeDiscardStringContext (removePrefix "${dirs.client-overrides}/" path);
            value = path;
          }) (listFilesRecursive dirs.client-overrides)
        );

        server-overrides = listToAttrs (
          map (path: {
            name = unsafeDiscardStringContext (removePrefix "${dirs.server-overrides}/" path);
            value = path;
          }) (listFilesRecursive dirs.server-overrides)
        );

        overrides-plus-client-overrides = overrides // client-overrides;
        overrides-plus-server-overrides = overrides // server-overrides;
      };

      fileMap = {
        overrides-plus-client-overrides = filterAttrs (n: _: !(hasPrefix "saves/" n) && !(hasPrefix "world/" n)) allFileMap.overrides-plus-client-overrides;
        overrides-plus-server-overrides = filterAttrs (n: _: !(hasPrefix "saves/" n) && !(hasPrefix "world/" n)) allFileMap.overrides-plus-server-overrides;
      };

      saves = rec {
        overrides =
          if pathIsDirectory dirs.overrides-saves
          then
            listToAttrs (
              map (path: {
                name = unsafeDiscardStringContext (removePrefix "${dirs.overrides-saves}/" path);
                value = path;
              }) (listDirs dirs.overrides-saves)
            )
          else {};

        client-overrides =
          if pathIsDirectory dirs.client-overrides-saves
          then
            listToAttrs (
              map (path: {
                name = unsafeDiscardStringContext (removePrefix "${dirs.client-overrides-saves}/" path);
                value = path;
              }) (listDirs dirs.client-overrides-saves)
            )
          else {};

        overrides-plus-client-overrides = overrides // client-overrides;
      };

      world = rec {
        overrides =
          if pathIsDirectory dirs.overrides-world
          then dirs.overrides-world
          else null;

        server-overrides =
          if pathIsDirectory dirs.server-overrides-world
          then dirs.server-overrides-world
          else null;

        overrides-plus-server-overrides =
          if server-overrides != null
          then server-overrides
          else overrides;
      };
    in {
      inherit
        index
        fabricLoaderVersion
        quiltLoaderVersion
        forgeLoaderVersion
        neoforgeLoaderVersion
        allFileMap
        fileMap
        saves
        world
        ;
      inherit
        (fileMap)
        overrides
        client-overrides
        server-overrides
        overrides-plus-client-overrides
        overrides-plus-server-overrides
        ;
      inherit (index) name versionId formatVersion;
      inherit minecraftVersion;
      __toString = self: self.src;
      src = unpacked;
    };
  };

  perSystem = {
    flakeConfig,
    pkgs,
    ...
  }: {
    nixcraft.builders = {
      unpackMrpack = flakeConfig.nixcraft.lib.builders.unpackMrpack pkgs;
      parseMrpack = flakeConfig.nixcraft.lib.builders.parseMrpack pkgs;
    };
  };
}
