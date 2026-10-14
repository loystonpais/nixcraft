{
  pkgs,
  ...
}:
pkgs.writers.writePython3Bin "nixcraft-client-fetch-assets" {
  doCheck = false;
  makeWrapperArgs = [
    "--set-default"
    "SSL_CERT_FILE"
    "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
  ];
} (builtins.readFile ../../scripts/client-fetch-assets.py)
