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

      runInRepoRootUpdateAssetSha256For =
        lib.mapAttrs' (
          version: versionInfo:
            lib.nameValuePair (lib.replaceString "." "-" "${version}")
            (pkgs.writeShellScriptBin "update-asset-sha256-for-${version}" ''
              ${lib.getExe runInRepoRoot.update-asset-sha256} "${builders.mkAssetsDir {
                versionData = lib.nixcraft.readJSON (builders.fetchSha1 versionInfo);
              }}/objects"
            '')
        )
        sources.normalized-manifest.versions;

      legacyPackages = {
        inherit runInRepoRoot runInRepoRootUpdateAssetSha256For;
      };

      packages =
        lib.nixcraft.importPackages "${self}/packages" pkgs {};
    in {
      inherit packages;
      inherit legacyPackages;
    };
  };
}
