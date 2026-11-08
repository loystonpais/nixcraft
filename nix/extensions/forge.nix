{
  config,
  lib,
  ...
} @ flakeArgs: let
  inherit (config.nixcraft) sources;
in {
  nixcraft.instance.extensions = [
    ({
      config,
      pkgs,
      lib,
      ...
    }: let
      inherit (flakeArgs.config.nixcraft.lib.minecraftVersion) ls grEq;

      # FML moved from `cpw.mods.fml` to `net.minecraftforge.fml` in 1.8
      fmlPackage =
        if ls config.forgeLoader.minecraftVersion "1.8"
        then "cpw.mods.fml"
        else "net.minecraftforge.fml";
    in {
      imports = [
        (flakeArgs.config.nixcraft.lib.forgeLike.mkLoaderModule {
          inherit pkgs;
          loaderName = "forgeLoader";
          description = "forge loader";
          versionDynOption = flakeArgs.config.nixcraft.lib.options.forgeLoaderVersionDyn;
          loaderSources = sources.forge;
        })
      ];

      config = lib.mkMerge [
        {
          forgeLoader = {
            # Log4Shell fix for ForgeWrapper based versions
            extraDependencies = lib.optionals (!config.forgeLoader.meta.isLegacy) [
              "org.apache.logging.log4j:log4j-api:2.17.0"
              "org.apache.logging.log4j:log4j-core:2.17.0"
            ];

            legacy = {
              tweakClass = "${fmlPackage}.common.launcher.FMLTweaker";
              serverMainClass = "${fmlPackage}.relauncher.ServerLaunchWrapper";
            };

            # Unobfuscated Forge (26.1+) ships the whole patched client as a library;
            # the vanilla jar would otherwise be picked up first as the `minecraft` module.
            replacesMinecraftJar = grEq config.forgeLoader.minecraftVersion "26.1";
          };
        }

        (lib.mkIf config.forgeLoader.enable (lib.mkMerge [
          (lib.mkIf (config._instanceType == "client") (lib.mkMerge [
            # Forge client on Minecraft 26.1 under Linux
            (lib.mkIf (
              config.fixBugs
              && pkgs.stdenv.hostPlatform.isLinux
              && (config.version == "26.1")
              && !config.waywall.enable
            ) {
              # Forge 62.0.9's early window on MC 26.1 uses LWJGL 3.4.1 (GLFW 3.4) and initializes
              # without specifying the X11 platform hint. This causes GLFW to pick native Wayland,
              # fail on window positioning, and crash vanilla's GLX._initGlfw pre-flight check.
              envVars.XDG_SESSION_TYPE = lib.mkDefault "x11";
              envVars.GDK_BACKEND = lib.mkDefault "x11";
            })
          ]))
        ]))
      ];
    })
  ];

  nixcraft.docs.examples.client.forge = {
    version = "1.20.1";
    forgeLoader.enable = true;
    java.memory = 6144;
  };

  nixcraft.docs.readme.sections.forge = {
    order = 62;
    template = ''
      ### Forge

      Enables Minecraft Forge for client or server instances. The right Forge version for your Minecraft version is picked automatically.

      ```nix
      { ... }: {
        nixcraft.client.instances.forge = {{ examples.client.forge | to_nix | indent(2) }};
      }
      ```
    '';
  };
}
