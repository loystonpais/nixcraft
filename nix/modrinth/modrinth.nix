{
  nixcraft.sources.modrinth = builtins.fromJSON (builtins.readFile ./lock.json);

  perSystem = {pkgs, ...}: let
    update-modrinth-sources =
      pkgs.writers.writePython3Bin "update-modrinth-sources" {
        doCheck = false;
        libraries = with pkgs.python3Packages; [requests];
      }
      (builtins.readFile ./update.py);
  in {
    nixcraft.runInRepoRoot.update-modrinth-sources = update-modrinth-sources;
  };
}
