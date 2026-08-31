{
  pkgs,
  ...
}:
pkgs.writers.writePython3Bin "nixcraft-client-auth" {
  doCheck = false;
} (builtins.readFile ../../scripts/client-auth.py)
