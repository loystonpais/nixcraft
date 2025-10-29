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
  imports = [
    inputs.devenv.flakeModule
  ];
  config = {
    debug = true;

    systems = ["x86_64-linux"];

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

      runInRepoRoot = {
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
      };

      legacyPackages = {
        inherit runInRepoRoot;
      };

      packages = lib.nixcraft.importPackages "${self}/packages" pkgs {
        inherit sources;
        inherit builders;
        inherit submodules;
      };

      optionDocs = {
        nixcraft = let
          evaluated = lib.evalModules {
            modules = with submodules; [
              nixcraftModule
            ];

            specialArgs = {
              clientDirPrefix = "/(root)/.local/share/nixcraft/client/instances";
              serverDirPrefix = "/(root)/.local/share/nixcraft/server/instances";
              name = "nixcraft";
            };
          };
        in
          pkgs.nixosOptionsDoc {
            options = builtins.removeAttrs evaluated.options ["_module"];
            warningsAreErrors = false;
          };
      };

      devenv = {
        shells.default = {
          config = {
            env.GREET = "devenv";

            packages = with pkgs; [
              # Generating docs
              mdbook
            ];

            tasks = {
              "docs:generate" = {
                exec = ''
                  rm -f NIXCRAFT-OPTIONS.gen.md
                  install -m 0644 \
                    ${optionDocs.nixcraft.optionsCommonMark} \
                    NIXCRAFT-OPTIONS.gen.md
                '';
                cwd = "docs";
                execIfModified = [
                  "submodules/*.nix"
                  "modules/flakeModules/**/*.nix"
                  "docs"
                ];
                before = ["docs:build"];
              };

              "docs:build" = {
                exec = "mdbook build";
                cwd = "docs";
                before = ["devenv:processes:open-docs"];
              };
            };

            processes = {
              open-docs = {
                exec = "mdbook serve -p 4000 -o";
                cwd = "docs";
              };
            };

            enterTest = ''
              echo "Running tests"
              git --version | grep --color=auto "${pkgs.git.version}"
            '';

            # https://devenv.sh/git-hooks/
            # git-hooks.hooks.shellcheck.enable = true;
          };
        };
      };
    in {
      inherit packages;
      inherit legacyPackages;
      inherit devenv;
    };
  };
}
