{
  lib,
  sources,
  forgeLikeLoaderModule,
  ...
}: {config, ...}: let
  inherit (lib.nixcraft.minecraftVersion) ls grEq;
in {
  imports = [forgeLikeLoaderModule];

  options = {
    enable = lib.mkEnableOption "forge loader";

    version = lib.nixcraft.options.forgeLoaderVersionDyn;

    minecraftVersion = lib.nixcraft.options.minecraftVersionDyn;
  };

  config = let
    # FML moved from `cpw.mods.fml` to `net.minecraftforge.fml` in 1.8
    fmlPackage =
      if ls config.minecraftVersion "1.8"
      then "cpw.mods.fml"
      else "net.minecraftforge.fml";
  in {
    meta.sources = sources.forge;

    # Log4Shell fix for ForgeWrapper based versions
    extraDependencies = lib.optionals (!config.meta.isLegacy) [
      "org.apache.logging.log4j:log4j-api:2.17.0"
      "org.apache.logging.log4j:log4j-core:2.17.0"
    ];

    legacy = {
      tweakClass = "${fmlPackage}.common.launcher.FMLTweaker";
      serverMainClass = "${fmlPackage}.relauncher.ServerLaunchWrapper";
    };

    # Unobfuscated Forge (26.1+) ships the whole patched client as a library;
    # the vanilla jar would otherwise be picked up first as the `minecraft` module.
    replacesMinecraftJar = grEq config.minecraftVersion "26.1";
  };
}
