{
  nixcraft.lib.fileMerge.mkPackage = pkgs:
    pkgs.writers.writePython3Bin "nixcraft-file-merge" {
      doCheck = false;
      libraries = with pkgs.python3Packages; [
        tomlkit
        ruamel-yaml
      ];
    } (builtins.readFile ./file-merge.py);

  perSystem = {
    flakeConfig,
    pkgs,
    ...
  }: {
    packages.file-merge = flakeConfig.nixcraft.lib.fileMerge.mkPackage pkgs;
  };
}
