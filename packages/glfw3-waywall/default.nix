{
  glfw3,
  fetchpatch,
  ...
}:
glfw3.overrideAttrs (o: {
  patches =
    o.patches
    ++ [
      (fetchpatch {
        url = "https://raw.githubusercontent.com/tesselslate/waywall/be3e018bb5f7c25610da73cc320233a26dfce948/contrib/glfw.patch";
        hash = "sha256-8Sho5Yoj/FpV7utWz3aCXNvJKwwJ3ZA3qf1m2WNxm5M=";
      })
    ];
})
