{
  lib,
  flake-parts-lib,
  config,
  ...
} @ top: let
  inherit (lib) mkOption types mkDefault;
  inherit (flake-parts-lib) mkPerSystemOption;
in {
  options = {
    nixcraft = {
      sources = mkOption {
        type = types.lazyAttrsOf types.raw;
      };

      lib = mkOption {
        type = types.lazyAttrsOf (types.either (types.lazyAttrsOf types.raw) types.raw);
        default = {};
      };

      instance = {
        extensions = mkOption {
          type = types.listOf types.deferredModule;
          default = [];
        };
        module = mkOption {
          type = types.deferredModule;
        };
      };

      client = {
        instance = {
          extensions = mkOption {
            type = types.listOf types.deferredModule;
            default = [];
          };
          module = mkOption {
            type = types.deferredModule;
          };
        };
        module = mkOption {
          type = types.deferredModule;
        };
      };

      server = {
        instance = {
          extensions = mkOption {
            type = types.listOf types.deferredModule;
            default = [];
          };
          module = mkOption {
            type = types.deferredModule;
          };
        };
        module = mkOption {
          type = types.deferredModule;
        };
      };

      module = mkOption {
        type = types.deferredModule;
      };
    };

    flake = {
      lib = mkOption {
        type = types.lazyAttrsOf types.raw;
        default = {};
      };

      flakeModules = mkOption {
        type = types.lazyAttrsOf types.deferredModule;
        default = {};
      };

      flakeModule = mkOption {
        type = types.deferredModule;
      };

      homeManagerModules = mkOption {
        type = types.lazyAttrsOf types.deferredModule;
        default = {};
      };

      homeModules = mkOption {
        type = types.lazyAttrsOf types.deferredModule;
        default = {};
      };
    };
  };

  options.perSystem = mkPerSystemOption ({
    config,
    pkgs,
    system,
    ...
  }: {
    options.nixcraft = {
      builders = mkOption {
        type = types.lazyAttrsOf types.raw;
        default = {};
      };

      runInRepoRoot = mkOption {
        type = types.lazyAttrsOf types.package;
        default = {};
      };
    };
  });

  config = {
    flake.lib = mkDefault config.nixcraft.lib;
    flake.flakeModule = mkDefault (config.flake.flakeModules.default or {});
    flake.homeModules = mkDefault (config.flake.homeManagerModules or {});

    _module.args = {
      sources = config.nixcraft.sources;
      nixcraftLib = config.nixcraft.lib;
      localFlake = ./..;
    };

    perSystem = {config, ...}: {
      legacyPackages.runInRepoRoot = config.nixcraft.runInRepoRoot;

      _module.args = {
        builders = config.nixcraft.builders;
        packages = config.packages;
        sources = top.config.nixcraft.sources;
        flakeConfig = top.config;
      };
    };
  };
}
