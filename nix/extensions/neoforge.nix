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
}
