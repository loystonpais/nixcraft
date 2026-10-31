{
  nixcraft.lib.bwrap.mkPackage = pkgs:
    pkgs.writeShellApplication {
      name = "nixcraft-bwrap";
      runtimeInputs = with pkgs; [
        bubblewrap
        coreutils
        gnugrep
        gawk
        findutils
      ];
      runtimeEnv = {
        MESA_PATH = "${pkgs.mesa}";
      };
      text = builtins.readFile ./bwrap.sh;
    };

  perSystem = {
    flakeConfig,
    pkgs,
    ...
  }: let
    pkg = flakeConfig.nixcraft.lib.bwrap.mkPackage pkgs;
  in {
    packages.bwrap-script = pkg;
    packages.bwrap = pkg;
  };
}
