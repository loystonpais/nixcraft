{
  pkgs,
  sources,
  ...
}:
pkgs.writers.writePython3Bin "nixcraft-auth" {
  doCheck = false;
} sources."nixcraft-auth.py"
