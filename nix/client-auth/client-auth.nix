{
  nixcraft.lib.clientAuth.mkPackage = pkgs:
    pkgs.writers.writePython3Bin "nixcraft-client-auth" {
      doCheck = false;
    } (builtins.readFile ./client-auth.py);

  perSystem = {
    flakeConfig,
    pkgs,
    ...
  }: {
    packages.client-auth = flakeConfig.nixcraft.lib.clientAuth.mkPackage pkgs;
  };
}
