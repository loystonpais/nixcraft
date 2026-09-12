{
  pkgs,
  lib,
  ...
}: {
  name ? "minecraft-asset-dir",
  hash,
  indexFile,
  assetType ? "objects",
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
  mkdir -p "$out/indexes"
  ln -s ${indexFile} "$out/indexes/${assetType}.json"

  python3 ${../scripts/client-fetch-assets.py} \
    --index ${indexFile} \
    --asset-type "${assetType}" \
    --out-dir "$out" \
    ${lib.optionalString (readCacheDirs != []) "--read-cache-dirs ${lib.concatStringsSep " " (map lib.escapeShellArg readCacheDirs)}"} \
    ${lib.optionalString (writeCacheDir != null) "--write-cache-dir ${lib.escapeShellArg writeCacheDir}"} \
    --threads ${toString threads} \
    --retries ${toString retries} \
    --timeout ${toString timeout}
''
