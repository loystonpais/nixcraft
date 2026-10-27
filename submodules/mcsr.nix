{
  lib,
  pkgs,
  ...
}: {config, ...}: {
  options = {
    mcsr = {
      enable = lib.mkEnableOption "MCSR";
    };
  };

  config = let
    approvedGlfw = {
      x86_64-linux = {
        url = "https://github.com/loystonpais/minecraft-sources/releases/download/mcsr-glfw-20261019/libglfw-3.4-linux-x86_64.so";
        sha512 = "5aa9dc21354770202efd01180c6925fd9bdbe6f1fdddd0b4c23fd7a65de3c287a96d290862094ecdbff3061c7d3d341b3891ea7ced402d4957247882828c6278";
      };
      aarch64-linux = {
        url = "https://github.com/loystonpais/minecraft-sources/releases/download/mcsr-glfw-20261019/libglfw-3.4-linux-arm64.so";
        sha512 = "b611a67bb1b1f73653d4d01de8eb1b8f12b41d7bf4601b2f6927165631b17edc5844f3745b1fc6ce647cb936fe70ef02ea567715ef01ef7df96bd7148f7a6e16";
      };
    };
  in
    lib.mkMerge [
      (lib.mkIf config.mcsr.enable (lib.mkMerge [
        (lib.mkIf (
            pkgs.stdenv.hostPlatform.isLinux
            && lib.nixcraft.minecraftVersion.grEq config.version "1.13"
            && lib.nixcraft.minecraftVersion.ls config.version "26.1"
          ) {
            java.D."org.lwjgl.glfw.libname" =
              lib.mkForce "${pkgs.fetchurl approvedGlfw.${pkgs.stdenv.hostPlatform.system}}";
          })
      ]))
    ];
}
