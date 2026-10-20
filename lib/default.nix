{
  lib,
  sources,
  ...
}:
lib.fix (
  nixcraft:
    (import ./filesystem.nix {inherit lib sources nixcraft;})
    // (import ./importers.nix {inherit lib sources nixcraft;})
    // (import ./instance.nix {inherit lib sources nixcraft;})
    // (import ./serialization.nix {inherit lib sources nixcraft;})
    // (import ./module-utils.nix {inherit lib sources nixcraft;})
    // (import ./runtime.nix {inherit lib sources nixcraft;})
    // (import ./options.nix {inherit lib sources nixcraft;})
    // (import ./versions.nix {inherit lib sources nixcraft;})
    // (import ./types.nix {inherit lib sources nixcraft;})
    // (import ./aria2c.nix {inherit lib sources nixcraft;})
    // (import ./maven.nix {inherit lib sources nixcraft;})
    // (import ./file-merge.nix {inherit lib sources nixcraft;})
    // (import ./forge-like.nix {inherit lib sources nixcraft;})
)
