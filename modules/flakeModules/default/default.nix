{
  lib,
  flake-parts-lib,
  self,
  inputs,
  ...
} @ flakeModuleArgs: let
  sourcesRoot = import inputs.sources {};
  sources =
    (sourcesRoot.version."1")
    // {
      modrinth = builtins.fromJSON (builtins.readFile "${self}/sources/modrinth/lock.json");
    };

  nixcraftLib = import "${self}/lib" {inherit lib sources;};
  extendedLib = flakeModuleArgs.lib.extend (self: super: {
    nixcraft = nixcraftLib;
  });

  args = flakeModuleArgs // {
    localFlake = self;
    inherit sources;
    lib = extendedLib;
  };

  homeModules = {
    default = flake-parts-lib.importApply "${self}/modules/homeModules/default" args;
  };

  nixosModules = {
    default = flake-parts-lib.importApply "${self}/modules/nixosModules/default" args;
  };
in {
  config = {
    _module.args.lib = extendedLib;
    debug = true;

    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    flake = {
      lib = nixcraftLib;
      inherit homeModules;
      inherit nixosModules;
    };

    perSystem = {
      config,
      system,
      pkgs,
      ...
    }: let
      builders = extendedLib.nixcraft.importBuilders "${self}/builders" {
        inherit pkgs;
        lib = extendedLib;
        inherit sources;
        inherit system;
      };

      submoduleArgs =
        flakeModuleArgs
        // {
          inherit pkgs;
          inherit system;
          inherit sources;
          lib = extendedLib;
        }
        // builders;

      submodules = extendedLib.nixcraft.importSubmodules "${self}/submodules" submoduleArgs;

      optionDocs = {
        nixcraft = let
          evaluated = extendedLib.evalModules {
            modules = with submodules; [
              nixcraftModule
            ];

            specialArgs = {
              clientDirPrefix = "/(root)/.local/share/nixcraft/client/instances";
              clientAuthDirPrefix = "/(root)/.local/share/nixcraft/client/auth";
              serverDirPrefix = "/(root)/.local/share/nixcraft/server/instances";
              clientExternalAssetsDirPrefix = "/(root)/.local/share/nixcraft/client/assets";
              clientSkinsDirPrefix = "/(root)/.local/share/nixcraft/client/skins";
              clientExternalAssetsLookupPaths = [
                "/(root)/.local/share/PrismLauncher/assets"
                "/(root)/.minecraft/assets"
                "/var/cache/nixcraft/asset-objects"
              ];
              name = "nixcraft";
            };
          };
        in
          pkgs.nixosOptionsDoc {
            options = builtins.removeAttrs evaluated.options ["_module"];
            warningsAreErrors = false;
          };
      };

      runInRepoRoot = {
        update-doc-options = pkgs.writeShellScriptBin "update-doc-options" ''
          rm -f docs/NIXCRAFT-OPTIONS.gen.md
          install -m 0644 \
            ${optionDocs.nixcraft.optionsCommonMark} \
            docs/NIXCRAFT-OPTIONS.gen.md
        '';

        update-modrinth-sources =
          pkgs.writers.writePython3Bin "update-modrinth-sources" {
            doCheck = false;
            libraries = with pkgs.python3Packages; [requests];
          }
          (builtins.readFile "${self}/sources/modrinth/update.py");
      };

      legacyPackages = {
        inherit runInRepoRoot;
      };

      packages = extendedLib.nixcraft.importPackages "${self}/packages" pkgs {
        lib = extendedLib;
        inherit sources;
        inherit builders;
        inherit submodules;
      };
    in {
      inherit packages;
      inherit legacyPackages;
    };
  };
}
