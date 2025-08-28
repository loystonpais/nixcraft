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
in {
  imports = [
    (
      flake-parts-lib.mkTransposedPerSystemModule
      {
        name = "scripts";
        option = lib.mkOption {
          type = lib.types.lazyAttrsOf lib.types.raw;
          default = {};
        };
        file = ./default.nix;
      }
    )
  ];

  config = {
    systems = ["x86_64-linux"];
    flake = {
      lib = lib.nixcraft;
      inherit homeModules;
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

      update-asset-sha256 =
        pkgs.writers.writePython3Bin "update-asset-sha256" {
          flakeIgnore = ["E501" "E265"];
        }
        (sources."update-asset-sha256.py");
      update-version-manifest-v2 =
        pkgs.writeShellScriptBin "update-version-manifest-v2"
        (sources."update-version-manifest-v2.sh");

      update-asset-sha256-for-versions =
        lib.mapAttrs' (
          version: versionInfo:
            lib.nameValuePair (lib.replaceString "." "-" "update-asset-sha256-for-${version}")
            (pkgs.writeShellScriptBin "update-asset-sha256-for-${version}" ''
              ${lib.getExe update-asset-sha256} "${builders.mkAssetsDir {
                versionData = lib.nixcraft.readJSON (builders.fetchSha1 versionInfo);
              }}/objects"
            '')
        )
        sources.normalized-manifest.versions;

      packages =
        (lib.nixcraft.importPackages "${self}/packages" pkgs {})
        // {
          inherit update-asset-sha256 update-version-manifest-v2;
        }
        // update-asset-sha256-for-versions;
    in {
      inherit packages;
    };
  };
}
