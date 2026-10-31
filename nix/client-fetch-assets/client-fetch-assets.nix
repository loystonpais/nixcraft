{
  nixcraft.lib.clientFetchAssets = {
    scriptPath = ./client-fetch-assets.py;

    mkPackage = pkgs:
      pkgs.writers.writePython3Bin "nixcraft-client-fetch-assets" {
        doCheck = false;
        makeWrapperArgs = [
          "--set-default"
          "SSL_CERT_FILE"
          "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        ];
      } (builtins.readFile ./client-fetch-assets.py);
  };

  perSystem = {
    flakeConfig,
    pkgs,
    ...
  }: {
    packages.client-fetch-assets = flakeConfig.nixcraft.lib.clientFetchAssets.mkPackage pkgs;
  };
}
