{
  config,
  lib,
  ...
} @ flakeArgs: {
  nixcraft.client.instance.extensions = [
    ({
      config,
      pkgs,
      lib,
      ...
    }: {
      options = {
        mcsr = {
          enable = lib.mkEnableOption "MCSR";

          glfwVersion = lib.mkOption {
            type = lib.types.enum ["3.4" "3.5.1"];
            default = "3.4";
            description = "Approved GLFW version for MCSR.";
          };
        };
      };

      config = let
        approvedGlfw = {
          "3.4" = {
            x86_64-linux = {
              url = "https://github.com/loystonpais/minecraft-sources/releases/download/mcsr-glfw-20261019/libglfw-3.4-linux-x86_64.so";
              sha512 = "5aa9dc21354770202efd01180c6925fd9bdbe6f1fdddd0b4c23fd7a65de3c287a96d290862094ecdbff3061c7d3d341b3891ea7ced402d4957247882828c6278";
            };
            aarch64-linux = {
              url = "https://github.com/loystonpais/minecraft-sources/releases/download/mcsr-glfw-20261019/libglfw-3.4-linux-arm64.so";
              sha512 = "b611a67bb1b1f73653d4d01de8eb1b8f12b41d7bf4601b2f6927165631b17edc5844f3745b1fc6ce647cb936fe70ef02ea567715ef01ef7df96bd7148f7a6e16";
            };
          };
          "3.5.1" = {
            x86_64-linux = {
              url = "https://github.com/loystonpais/minecraft-sources/releases/download/mcsr-glfw-20261019/libglfw-3.5.1-linux-x86_64.so";
              sha512 = "9c6f51924ca376ba13936157778de2e7e35be34c69ab904241db32266161f3184974e08daba73eeea91afbab329b23c8e088985845562946e3c015faca9ab036";
            };
            aarch64-linux = {
              url = "https://github.com/loystonpais/minecraft-sources/releases/download/mcsr-glfw-20261019/libglfw-3.5.1-linux-arm64.so";
              sha512 = "248bcf2cb96275057823bc6c8ecb53a8ac7b0606ed31a42cc8d5f0c01b53ae64d4fe7e12a8095549796b549375f3bac460a47158cec03b733fca10e72facb656";
            };
          };
        };
      in
        lib.mkMerge [
          (lib.mkIf config.mcsr.enable (lib.mkMerge [
            (lib.mkIf (
                pkgs.stdenv.hostPlatform.isLinux
                && flakeArgs.config.nixcraft.lib.minecraftVersion.grEq config.version "1.13"
                && flakeArgs.config.nixcraft.lib.minecraftVersion.ls config.version "26.1"
              ) {
                java.D."org.lwjgl.glfw.libname" =
                  lib.mkForce "${pkgs.fetchurl approvedGlfw.${config.mcsr.glfwVersion}.${pkgs.stdenv.hostPlatform.system}}";
              })
          ]))
        ];
    })
  ];
}
