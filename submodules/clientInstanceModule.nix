{
  lib,
  pkgs,
  forgeLoaderModule,
  fabricLoaderModule,
  mrpackModule,
  javaSettingsModule,
  genericInstanceModule,
  waywallModule,
  minecraftAccountModule,
  sources,
  fetchSha1,
  mkAssetsDir,
  mkLibDir,
  mkNativeLibDir,
  inputs,
  system,
  ...
}: let
  inherit (lib) escapeShellArgs escapeShellArg concatStringsSep;
  inherit (lib.nixcraft.filesystem) listJarFilesRecursive;
in
  {
    name,
    config,
    shared ? {},
    ...
  }: {
    imports = [genericInstanceModule];

    options = {
      enable = lib.mkEnableOption "client instance";

      waywall = lib.mkOption {
        type = lib.types.submodule waywallModule;
      };

      enableNvidiaOffload = lib.mkEnableOption "nvidia offload";

      enableFastAssetDownload = lib.mkEnableOption "fast asset downloading using aria2c (hash needs to be provided)";

      assetHash = lib.mkOption {
        type = lib.types.str;
      };

      account = lib.mkOption {
        type = with lib.types; nullOr (submodule minecraftAccountModule);
      };

      launchShellCommandString = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = concatStringsSep " " [
          ''"${config.java.package}/bin/java"''
          "${config.java.finalArgumentShellString}"
          (escapeShellArg config._classSettings.mainClass)
          (escapeShellArgs config.finalArguments)

          # unmodded client doesn't launch if access token is not provided
          "--accessToken $(cat ${
            if (config.account != null && config.account.accessTokenPath != null)
            then escapeShellArg config.account.accessTokenPath
            else pkgs.writeText "dummy" "dummy"
          })"
        ];
      };

      extraArguments = lib.mkOption {
        type = with lib.types; listOf str;
        default = [];
      };

      finalArguments = lib.mkOption {
        type = with lib.types; listOf str;
        readOnly = true;
        default = with lib;
          concatLists [
            ["--version" config._classSettings.version]
            ["--assetsDir" "${config._classSettings.assetsDir}"]
            ["--assetIndex" config._classSettings.assetIndex]

            (
              let
                cond = config._classSettings.gameDir != null;
              in
                (optional cond "--gameDir") ++ (optional cond config._classSettings.gameDir)
            )

            (
              let
                cond = config._classSettings.username != null;
              in
                (optional cond "--username") ++ (optional cond config._classSettings.username)
            )

            (
              let
                cond = config._classSettings.uuid != null;
              in
                (optional cond "--uuid") ++ (optional cond config._classSettings.uuid)
            )

            (
              let
                cond = config._classSettings.height != null;
              in
                (optional cond "--height") ++ (optional cond (toString config._classSettings.height))
            )

            (
              let
                cond = config._classSettings.width != null;
              in
                (optional cond "--width") ++ (optional cond (toString config._classSettings.width))
            )

            (optional (config._classSettings.fullscreen) "--fullscreen")

            config.extraArguments
          ];
      };

      _classSettings = lib.mkOption {
        type = with lib.types;
          submodule {
            options = {
              mainClass = lib.mkOption {
                type = lib.types.str;
              };

              version = lib.mkOption {
                type = lib.types.str;
              };

              assetsDir = lib.mkOption {
                type = lib.types.path;
              };

              assetIndex = lib.mkOption {
                type = lib.types.str;
              };

              gameDir = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };

              username = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };

              uuid = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };

              fullscreen = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };

              height = lib.mkOption {
                type = lib.types.nullOr lib.types.ints.positive;
                default = null;
              };

              width = lib.mkOption {
                type = lib.types.nullOr lib.types.ints.positive;
                default = null;
              };
            };
          };
      };
    };

    config = lib.mkMerge [
      shared

      {
        # set waywall stuff
        waywall = {
          package = pkgs.waywall;
        };
      }

      {
        _classSettings = {
          mainClass = lib.mkDefault config.meta.versionData.mainClass;
          version = config.meta.versionData.id;
          assetIndex = config.meta.versionData.assets;
          assetsDir = mkAssetsDir {versionData = config.meta.versionData;};

          # TODO: fix this. not sure how to set this
          gameDir = lib.mkDefault null;
        };

        java.cp = listJarFilesRecursive (mkLibDir {versionData = config.meta.versionData;});

        # TODO: in javaSettingsModule try to implement this as an actual option
        java.extraArguments = ["-Djava.library.path=${mkNativeLibDir {versionData = config.meta.versionData;}}"];

        libs = with pkgs; [
          openal

          libpulseaudio
          alsa-lib
          libjack2
          pipewire

          xorg.libXcursor
          xorg.libXrandr
          xorg.libXxf86vm # Needed only for versions <1.13
          libGL
        ];

        # inform generic settings module the instance type
        _instanceType = "client";
      }

      # TODO: implement fast asset download
      (lib.mkIf config.enableFastAssetDownload {
        assetHash = lib.mkOptionDefault lib.fakeHash;
      })

      (lib.mkIf config.enableNvidiaOffload {
        envVars = {
          __NV_PRIME_RENDER_OFFLOAD = "1";
          __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          __VK_LAYER_NV_optimus = "NVIDIA_only";
        };
      })

      (lib.mkIf config.fabricLoader.enable {
        _classSettings.mainClass = config.fabricLoader.meta.clientMainClass;
      })

      (lib.mkIf config.waywall.enable {
        # waywall uses custom libglfw.so
        java.extraArguments = [
          "-Dorg.lwjgl.glfw.libname=${inputs.self.packages.${system}.glfw3-waywall}/lib/libglfw.so"
        ];
      })

      (lib.mkIf (config.account
        != null) {
        _classSettings.uuid = lib.mkIf (config.account.uuid != null) config.account.uuid;
        _classSettings.username = lib.mkIf (config.account.username != null) config.account.username;
      })
    ];
  }
