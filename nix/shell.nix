_: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      packages = [
        (pkgs.python3.withPackages (ps: [ps.requests]))
      ];
    };
  };
}
