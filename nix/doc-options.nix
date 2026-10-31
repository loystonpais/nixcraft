{localFlake, ...}: {
  perSystem = {
    pkgs,
    lib,
    flakeConfig,
    ...
  }: let
    optionDocs = {
      nixcraft = let
        evaluated = lib.evalModules {
          modules = [
            flakeConfig.nixcraft.module
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
            inherit pkgs;
            moduleType = "package";
          };
        };
      in
        pkgs.nixosOptionsDoc {
          options = builtins.removeAttrs evaluated.options ["_module"];
          warningsAreErrors = false;
        };
    };

    update-doc-options = pkgs.writeShellScriptBin "update-doc-options" ''
      rm -f docs/NIXCRAFT-OPTIONS.gen.md
      install -m 0644 \
        ${optionDocs.nixcraft.optionsCommonMark} \
        docs/NIXCRAFT-OPTIONS.gen.md
    '';
  in {
    nixcraft.runInRepoRoot.update-doc-options = update-doc-options;
  };
}
