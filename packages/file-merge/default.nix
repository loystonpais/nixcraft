{
  pkgs,
  ...
}:
pkgs.writers.writePython3Bin "nixcraft-file-merge" {
  doCheck = false;
  libraries = with pkgs.python3Packages; [
    tomlkit
    ruamel-yaml
  ];
} (builtins.readFile ../../scripts/file-merge.py)
