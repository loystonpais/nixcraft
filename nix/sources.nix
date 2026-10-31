{inputs, ...}: let
  sourcesRoot = import inputs.sources {};
in {
  nixcraft.sources = sourcesRoot.version."1";
}
