{
  lib,
  sources,
  forgeLikeLoaderModule,
  ...
}: {config, ...}: {
  imports = [forgeLikeLoaderModule];

  options = {
    enable = lib.mkEnableOption "NeoForge loader";

    version = lib.nixcraft.options.neoforgeLoaderVersionDyn;

    minecraftVersion = lib.nixcraft.options.minecraftVersionDyn;
  };

  config = {
    meta.sources = sources.neoforge;

    # Newer NeoForge metadata omits the launch target
    defaultLaunchTarget = "neoforgeclient";
  };
}
