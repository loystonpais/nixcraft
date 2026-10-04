{
  pkgs,
  ...
}:
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
  text = builtins.readFile ../../scripts/bwrap.sh;
}
