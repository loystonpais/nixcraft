{
  config,
  lib,
  ...
}: {
  nixcraft.lib.builders = {
    fetchAssetFromHash = pkgs: {
      sha1,
      assetSha256Map ? config.nixcraft.sources.asset-sha1-sha256-map,
      useBuiltinFetch ? false,
    }: let
      assetHashPath = config.nixcraft.lib.manifest.mkAssetHashPath sha1;
      url = "https://resources.download.minecraft.net/" + assetHashPath;
      src =
        if useBuiltinFetch && (assetSha256Map ? "${sha1}")
        then
          builtins.fetchurl {
            inherit url;
            sha256 = assetSha256Map."${sha1}";
          }
        else
          (pkgs.fetchurl {
            inherit url;
            inherit sha1;
            preferLocalBuild = true;
          }).overrideAttrs {
            allowSubstitutes = false;
          };
    in
      src;

    fetchAssetsPy = pkgs: {
      name ? "minecraft-asset-objects",
      hash,
      indexFile,
      readCacheDirs ? ["/var/cache/nixcraft/asset-objects"],
      writeCacheDir ? "/var/cache/nixcraft/asset-objects",
      threads ? 24,
      retries ? 5,
      timeout ? 15,
    }:
      pkgs.runCommand name {
        nativeBuildInputs = [pkgs.python3 pkgs.cacert];
        outputHashMode = "recursive";
        outputHash = hash;
        SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        PYTHONUNBUFFERED = "1";
        __impureHostDeps = readCacheDirs ++ (lib.optional (writeCacheDir != null) writeCacheDir);
      } ''
        python3 ${config.nixcraft.lib.clientFetchAssets.scriptPath} \
          --index ${indexFile} \
          --out-dir "$out" \
          ${lib.optionalString (readCacheDirs != []) "--read-cache-dirs ${lib.concatStringsSep " " (map lib.escapeShellArg readCacheDirs)}"} \
          ${lib.optionalString (writeCacheDir != null) "--write-cache-dir ${lib.escapeShellArg writeCacheDir}"} \
          --threads ${toString threads} \
          --retries ${toString retries} \
          --timeout ${toString timeout}
      '';

    mkAssetsDir = pkgs: {
      useExternalAssetsDir ? false,
      externalAssetsDir ? null,
      useFetchAssetsPy ? false,
      hash ? lib.fakeHash,
      skinsDir ? null,
      versionData,
      assetType ? versionData.assets,
      assetIndex ? config.nixcraft.lib.readJSON (pkgs.fetchurl { inherit (versionData.assetIndex) url sha1; }),
      objects ? assetIndex.objects,
      runCommandLocal ? pkgs.runCommandLocal,
      fetchAssetsPyArgs ? {},
    }: let
      inherit (builtins) attrValues mapAttrs;
      inherit (lib) concatMapStringsSep escapeShellArg;
      inherit (config.nixcraft.lib.manifest) mkAssetHashPath;

      assetIndexFile = pkgs.fetchurl {
        inherit (versionData.assetIndex) url sha1;
      };

      isLegacy = assetType == "legacy" || (assetIndex ? virtual && assetIndex.virtual);
      isPre1-6 = assetType == "pre-1.6" || (assetIndex ? map_to_resources && assetIndex.map_to_resources);

      objectsDownloadMethods = {
        default = let
          assetsWithPath = attrValues (mapAttrs (name: asset: {
              src = config.nixcraft.lib.builders.fetchAssetFromHash pkgs {sha1 = asset.hash;};
              path = "objects/${mkAssetHashPath asset.hash}";
            })
            objects);

          placeAssets =
            concatMapStringsSep "\n" (asset: ''
              mkdir -p "$out/${dirOf asset.path}"
              ln -sf ${asset.src} "$out/${asset.path}"
            '')
            assetsWithPath;
        in
          runCommandLocal "minecraft-asset-objects" {} ''
            ${placeAssets}
          '';

        viaFetchAssetsPy = config.nixcraft.lib.builders.fetchAssetsPy pkgs ({
            name = "minecraft-asset-objects-py";
            indexFile = assetIndexFile;
            inherit hash;
          }
          // fetchAssetsPyArgs);
      };

      objectsDrv =
        if useFetchAssetsPy
        then objectsDownloadMethods.viaFetchAssetsPy
        else objectsDownloadMethods.default;

      finalObjectsPath =
        if useExternalAssetsDir
        then "${externalAssetsDir}/objects"
        else "${objectsDrv}/objects";

      assetsDir = runCommandLocal "minecraft-assets-dir" {} ''
        mkdir -p $out/indexes
        ln -s ${assetIndexFile} $out/indexes/${assetType}.json
        ln -s ${escapeShellArg finalObjectsPath} $out/objects
        ${lib.optionalString (skinsDir != null) ''
          ln -s ${escapeShellArg skinsDir} $out/skins
        ''}
      '';

      legacyAssetsDir = runCommandLocal "minecraft-legacy-assets-dir" {} ''
        mkdir -p $out

        ${concatMapStringsSep "\n" (name: let
          asset = objects.${name};
          path = mkAssetHashPath asset.hash;
        in ''
          mkdir -p "$out/${dirOf name}"
          ln -s ${escapeShellArg "${finalObjectsPath}/${path}"} "$out/${name}"
        '') (builtins.attrNames objects)}
      '';

      pre1-6AssetsDir = runCommandLocal "minecraft-pre-1.6-assets-dir" {} ''
        mkdir -p $out

        ${concatMapStringsSep "\n" (name: let
          asset = objects.${name};
          path = mkAssetHashPath asset.hash;
        in ''
          mkdir -p "$out/${dirOf name}"
          ln -s ${escapeShellArg "${finalObjectsPath}/${path}"} "$out/${name}"
        '') (builtins.attrNames objects)}
      '';
    in
      if isLegacy
      then legacyAssetsDir
      else if isPre1-6
      then pre1-6AssetsDir
      else assetsDir;
  };

  perSystem = {
    flakeConfig,
    pkgs,
    ...
  }: {
    nixcraft.builders = {
      fetchAssetFromHash = flakeConfig.nixcraft.lib.builders.fetchAssetFromHash pkgs;
      fetchAssetsPy = flakeConfig.nixcraft.lib.builders.fetchAssetsPy pkgs;
      mkAssetsDir = flakeConfig.nixcraft.lib.builders.mkAssetsDir pkgs;
    };
  };
}
