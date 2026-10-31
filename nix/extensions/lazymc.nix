{
  ...
}: {
  nixcraft.server.instance.extensions = [
    ({
      config,
      pkgs,
      lib,
      ...
    }: {
      options = {
        lazymc = lib.mkOption {
          type = lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "lazymc";
              package = lib.mkOption {
                type = lib.types.package;
                default = pkgs.lazymc;
              };
              settings = lib.mkOption {
                type = lib.types.attrs;
                default = {};
              };
            };
          };
        };
      };

      config = lib.mkMerge [
        {
          lazymc.settings = {
            public.address = lib.mkDefault "0.0.0.0:25565";
            public.version = config.version;

            server.directory = config.absoluteDir;
            server.forge = config.forgeLoader.enable || config.neoForgeLoader.enable;
            server.command = config.finalLaunchShellCommandString;

            config.version = lib.mkDefault "0.2.11";
          };
        }

        (lib.mkIf config.lazymc.enable {
          files."lazymc.toml" = {
            type = "toml";
            value = config.lazymc.settings;
          };

          serverProperties = {
            max-tick-time = -1;
          };

          # Lazymc overwrites settings in server properties
          files."server.properties".method = lib.mkDefault "merge";
        })
      ];
    })
  ];
}
