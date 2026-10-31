{
  nixcraft.lib.glfw3Waywall.mkPackage = pkgs:
    pkgs.glfw3.overrideAttrs (oldAttrs: {
      patches =
        (oldAttrs.patches or [])
        ++ [
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/tesselslate/waywall/be3e018bb5f7c25610da73cc320233a26dfce948/contrib/glfw.patch";
            hash = "sha256-8Sho5Yoj/FpV7utWz3aCXNvJKwwJ3ZA3qf1m2WNxm5M=";
          })
        ];
    });

  perSystem = {
    flakeConfig,
    pkgs,
    ...
  }: {
    packages.glfw3-waywall = flakeConfig.nixcraft.lib.glfw3Waywall.mkPackage pkgs;
  };
}
