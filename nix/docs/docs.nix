{
  lib,
  flakeConfig,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.nixcraft.docs = {
    readme = {
      sections = mkOption {
        type = types.lazyAttrsOf (types.submodule {
          options = {
            order = mkOption {
              type = types.number;
              default = 100;
            };
            template = mkOption {
              type = types.lines;
            };
          };
        });
        default = {};
      };
    };

    examples = mkOption {
      type = types.lazyAttrsOf (types.lazyAttrsOf types.raw);
      default = {};
    };
  };

  config.nixcraft.docs.examples.quickstart = {
    flakeInputs = {
      _type = "raw";
      text = ''
        # flake.nix
        {
          inputs = {
            nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
            home-manager.url = "github:nix-community/home-manager";
            nixcraft = {
              url = "github:loystonpais/nixcraft";
              inputs.nixpkgs.follows = "nixpkgs";
            };
          };

          outputs = { nixpkgs, home-manager, nixcraft, ... }: {
            # Home Manager configuration
          };
        }'';
    };
    portable = {
      name = "survival-smp";
      version = "1.21.1";
      agreeToEula = true;
      paper.enable = true;
      serverProperties = {
        motd = "My Portable Nixcraft Server";
        difficulty = "hard";
      };
    };
  };

  config.nixcraft.docs.readme.sections = {
    header = {
      order = 10;
      template = builtins.readFile ./readme/header.md.j2;
    };

    features = {
      order = 20;
      template = builtins.readFile ./readme/features.md.j2;
    };

    quickstart = {
      order = 30;
      template = builtins.readFile ./readme/quickstart.md.j2;
    };

    showcaseHeader = {
      order = 58;
      template = builtins.readFile ./readme/showcase-header.md.j2;
    };

    options = {
      order = 70;
      template = builtins.readFile ./readme/options.md.j2;
    };
  };

  config.perSystem = {
    pkgs,
    flakeConfig,
    ...
  }: let
    optionDocs = let
      makeDocs = evaluated: options:
        pkgs.nixosOptionsDoc {
          inherit options;
          warningsAreErrors = false;
        };

      # The exported modules are wrapped in imports by flake-parts. Unwrap
      # their single module definition to avoid evaluating unrelated host
      # configuration options in a bare evalModules.
      moduleDefinition = module:
        if builtins.isFunction module || module ? options
        then module
        else moduleDefinition (builtins.head module.imports);

      nixosModule = (moduleDefinition flakeConfig.flake.nixosModules.default) {
        inherit pkgs lib;
        config = {};
      };
      nixos = lib.evalModules {modules = [{options = nixosModule.options;}];};

      homeManagerModule = (moduleDefinition flakeConfig.flake.homeManagerModules.default) {
        inherit pkgs lib;
        config.home.homeDirectory = "/(root)";
      };
      homeManager = lib.evalModules {modules = [{options = homeManagerModule.options;}];};

      client = lib.evalModules {
        modules = [
          flakeConfig.nixcraft.client.instance.module
          ({config, ...}: {
            version = lib.mkDefault "latest-release";
            absoluteDir = lib.mkDefault "/tmp/nixcraft-client/${config.name}";
            account = lib.mkDefault {offline = true;};
            binEntry.enable = lib.mkDefault true;
            desktopEntry.enable = lib.mkDefault true;
          })
        ];
        specialArgs = {
          shared = {};
          dirPrefix = null;
          readOnlyName = false;
          authDirPrefix = "/tmp/nixcraft-client-auth";
          externalAssetsDirPrefix = "/tmp/nixcraft-client-assets";
          skinsDirPrefix = "/tmp/nixcraft-client-skins";
          externalAssetsLookupPaths = ["/var/cache/nixcraft/asset-objects"];
          inherit pkgs;
          name = "default";
          moduleType = "package";
        };
      };

      server = lib.evalModules {
        modules = [
          flakeConfig.nixcraft.server.instance.module
          ({config, ...}: {
            version = lib.mkDefault "latest-release";
            absoluteDir = lib.mkDefault "/tmp/nixcraft-server/${config.name}";
            binEntry.enable = lib.mkDefault true;
          })
        ];
        specialArgs = {
          shared = {};
          dirPrefix = null;
          readOnlyName = false;
          inherit pkgs;
          name = "default";
          moduleType = "package";
        };
      };
    in {
      nixos = makeDocs nixos {nixcraft = nixos.options.nixcraft;};
      home-manager = makeDocs homeManager {nixcraft = homeManager.options.nixcraft;};
      client = makeDocs client (removeAttrs client.options ["_module"]);
      server = makeDocs server (removeAttrs server.options ["_module"]);
    };

    update-docs = let
      pythonEnv = pkgs.python3.withPackages (ps: [ps.jinja2]);

      # Collect sections sorted by order
      sortedSections = lib.sort (a: b: a.order < b.order) (lib.attrValues flakeConfig.nixcraft.docs.readme.sections);

      combinedReadmeTemplate = pkgs.writeText "README.md.j2" (
        lib.concatMapStringsSep "\n\n" (s: s.template) sortedSections
      );

      examplesJson = pkgs.writeText "examples.json" (
        builtins.toJSON flakeConfig.nixcraft.docs.examples
      );

      # Derive the full documentation in a pure derivation!
      docsDerivation = pkgs.stdenv.mkDerivation {
        name = "nixcraft-docs";
        nativeBuildInputs = [pythonEnv pkgs.nix];
        phases = ["buildPhase" "installPhase"];
        buildPhase = ''
          mkdir -p output/docs/human output/docs/agent

          ${pythonEnv}/bin/python3 ${./.}/docs.py --all \
            --nixos-options-json "${optionDocs.nixos.optionsJSON}/share/doc/nixos/options.json" \
            --home-manager-options-json "${optionDocs.home-manager.optionsJSON}/share/doc/nixos/options.json" \
            --client-options-json "${optionDocs.client.optionsJSON}/share/doc/nixos/options.json" \
            --server-options-json "${optionDocs.server.optionsJSON}/share/doc/nixos/options.json" \
            --examples-json "${examplesJson}" \
            --readme-template "${combinedReadmeTemplate}" \
            --no-verify-nix \
            --repo-root output
        '';
        installPhase = ''
          mkdir -p $out
          cp -r output/* $out/
        '';
      };
    in
      pkgs.writeShellScriptBin "update-docs" ''
        mkdir -p docs/human docs/agent
        rm -f docs/human/OPTIONS-TREE.md docs/agent/options-tree.toon
        rm -rf docs/human/options-tree docs/agent/options-tree
        cp -rf --no-preserve=mode,ownership ${docsDerivation}/docs/* docs/
        cp -f --no-preserve=mode,ownership ${docsDerivation}/README.md README.md
        echo "Documentation updated cleanly from pure derivation: ${docsDerivation}"
      '';
  in {
    nixcraft.runInRepoRoot.update-docs = update-docs;
  };
}
