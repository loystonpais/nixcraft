{
  pkgs,
  ...
}:
pkgs.writers.writePython3Bin "nixcraft-client-fetch-assets" {
  doCheck = false;
} (builtins.readFile ../../scripts/client-fetch-assets.py)
