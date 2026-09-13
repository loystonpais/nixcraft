{
  lib,
  flake-parts-lib,
  self,
  inputs,
  ...
} @ flakeModuleArgs: let
  sources = lib.nixcraft.importSources "${self}/sources";
  homeModules = {
    default = flake-parts-lib.importApply "${self}/modules/homeModules/default" ({
        localFlake = self;
        inherit sources;
      }
      // flakeModuleArgs);
  };

  nixosModules = {
    default = flake-parts-lib.importApply "${self}/modules/nixosModules/default" ({
        localFlake = self;
        inherit sources;
      }
      // flakeModuleArgs);
  };
in {
  config = {
    debug = true;

    systems = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];

    flake = {
      lib = lib.nixcraft;
      inherit homeModules;
      inherit nixosModules;
    };

    perSystem = {
      config,
      system,
      pkgs,
      ...
    }: let
      builders = lib.nixcraft.importBuilders "${self}/builders" {
        inherit pkgs;
        inherit lib;
        inherit sources;
        inherit system;
      };

      submoduleArgs =
        flakeModuleArgs
        // {
          inherit pkgs;
          inherit system;
          inherit sources;
        }
        // builders;

      submodules = lib.nixcraft.importSubmodules "${self}/submodules" submoduleArgs;

      optionDocs = {
        nixcraft = let
          evaluated = lib.evalModules {
            modules = with submodules; [
              nixcraftModule
            ];

            specialArgs = {
              clientDirPrefix = "/(root)/.local/share/nixcraft/client/instances";
              clientAuthDirPrefix = "/(root)/.local/share/nixcraft/client/auth";
              serverDirPrefix = "/(root)/.local/share/nixcraft/server/instances";
              clientExternalAssetsDirPrefix = "/(root)/.local/share/nixcraft/client/assets";
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

        update-asset-sha256 =
          pkgs.writers.writePython3Bin "update-asset-sha256" {
            doCheck = false;
          }
          (sources."update-asset-sha256.py");

        update-asset-sha256-all =
          pkgs.writers.writePython3Bin "update-asset-sha256-all" {
            doCheck = false;
          }
          (sources."update-asset-sha256-all.py");

        update-version-manifest-v2 =
          pkgs.writers.writePython3Bin "update-version-manifest-v2" {
            doCheck = false;
          }
          (sources."update-version-manifest-v2.py");

        update-paper-servers = pkgs.writers.writePython3Bin "update-paper-servers" {
          doCheck = false;
          libraries = with pkgs.python3Packages; [requests];
        } (builtins.readFile "${self}/sources/paper-servers/update.py");

        update-modloader-locks =
          pkgs.writers.writePython3Bin "update-modloader-locks" {
            doCheck = false;
            libraries = with pkgs.python3Packages; [requests];
          }
          (sources."update-modloader-locks.py");

        update-modrinth-sources =
          pkgs.writers.writePython3Bin "update-modrinth-sources" {
            doCheck = false;
            libraries = with pkgs.python3Packages; [requests];
          }
          (builtins.readFile "${self}/sources/modrinth/update.py");

        update-lwjgl-sources =
          pkgs.writers.writePython3Bin "update-lwjgl-sources" {
            doCheck = false;
          }
          (builtins.readFile "${self}/sources/lwjgl/update.py");
      };

      legacyPackages = {
        inherit runInRepoRoot;
      };

      packages = lib.nixcraft.importPackages "${self}/packages" pkgs {
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
