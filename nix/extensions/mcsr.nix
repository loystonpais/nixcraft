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

  nixcraft.docs.examples.client.rsg = {
    version = "1.16.1";
    mcsr.enable = true;
    waywall.enable = true;
    mrpack = {
      enable = true;
      file = {
        _type = "raw";
        text = ''
          pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/1uJaMUOm/versions/jIrVgBRv/SpeedrunPack-mc1.16.1-v5.3.0.mrpack";
            hash = "sha256-uH/fGFrqP2UpyCupyGjzFB87LRldkPkcab3MzjucyPQ=";
          }'';
      };
    };
    saves = {
      "Practice Map" = {
        _type = "raw";
        text = ''
          pkgs.fetchzip {
            url = "https://github.com/Dibedy/The-MCSR-Practice-Map/releases/download/1.0.1/MCSR.Practice.v1.0.1.zip";
            stripRoot = false;
            hash = "sha256-ukedZCk6T+KyWqEtFNP1soAQSFSSzsbJKB3mU3kTbqA=";
          }'';
      };
    };
    java = {
      package = {
        _type = "raw";
        text = "pkgs.jdk17";
      };
      minMemory = 3500;
      maxMemory = 3500;
      extraArguments = [
        "-XX:+UseZGC"
        "-XX:+AlwaysPreTouch"
        "-Dgraal.TuneInlinerExploration=1"
        "-XX:NmethodSweepActivity=1"
      ];
    };
    binEntry = {
      enable = true;
      name = "rsg";
    };
  };

  nixcraft.docs.readme.sections.mcsr = {
    order = 68;
    template = ''
      ### Minecraft Speedrunning (MCSR) & Waywall

      For MCSR speedrunning with Waywall overlays, practice map loading, official leaderboard-approved GLFW binaries (`mcsr.enable = true`).

      ```nix
      { pkgs, ... }: {
        nixcraft.client.instances.rsg = {{ examples.client.rsg | to_nix | indent(2) }};
      }
      ```
    '';
  };
}
