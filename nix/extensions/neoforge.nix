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
    }: {
      imports = [
        (flakeArgs.config.nixcraft.lib.forgeLike.mkLoaderModule {
          inherit pkgs;
          loaderName = "neoForgeLoader";
          description = "NeoForge loader";
          versionDynOption = flakeArgs.config.nixcraft.lib.options.neoforgeLoaderVersionDyn;
          loaderSources = sources.neoforge;
        })
      ];

      config = {
        neoForgeLoader = {
          # Newer NeoForge metadata omits the launch target
          defaultLaunchTarget = "neoforgeclient";
        };
      };
    })
  ];

  nixcraft.docs.examples.client.neoforge = {
    version = "1.21.1";
    neoForgeLoader.enable = true;
    java.memory = 6144;
  };

  nixcraft.docs.readme.sections.neoforge = {
    order = 62.5;
    template = ''
      ### NeoForge

      Enables NeoForge for client or server instances. The right NeoForge version for your Minecraft version is picked automatically.

      ```nix
      { ... }: {
        nixcraft.client.instances.neoforge = {{ examples.client.neoforge | to_nix | indent(2) }};
      }
      ```
    '';
  };
}
