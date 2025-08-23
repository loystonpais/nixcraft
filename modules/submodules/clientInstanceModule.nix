{
  lib,
  pkgs,
  forgeLoaderModule,
  fabricLoaderModule,
  mrpackModule,
  javaSettingsModule,
  genericInstanceSettingsModule,
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
    ...
  }: {
    options = {
      enable = lib.mkEnableOption "client instance";

      settings = lib.mkOption {
        type = lib.types.submodule genericInstanceSettingsModule;
      };

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
          ''"${config.settings.java.package}/bin/java"''
          "${config.settings.java.finalArgumentShellString}"
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

              # NOTE: We are using accessTokenPath (defined in instance) instead of accessToken
            };
          };
      };
    };

    config = lib.mkMerge [
      {
        # Settings stuff that the user usually doesn't need to alter
        _classSettings = {
          mainClass = lib.mkDefault config.settings.meta.versionData.mainClass;
          version = config.settings.meta.versionData.id;
          assetIndex = config.settings.meta.versionData.assets;
          assetsDir = mkAssetsDir {versionData = config.settings.meta.versionData;};

          # TODO: fix this. not sure how to set this
          gameDir = lib.mkDefault null;
        };

        # List and assign jar files from generated lib dir
        settings.java.cp = listJarFilesRecursive (mkLibDir {versionData = config.settings.meta.versionData;});

        # Pass native libraries
        # TODO: in javaSettingsModule try to implement this as an actual option
        settings.java.extraArguments = ["-Djava.library.path=${mkNativeLibDir {versionData = config.settings.meta.versionData;}}"];

        settings.libs = with pkgs; [
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
      }

      {
        # Set the instance name from attr
        settings.name = lib.mkOptionDefault name;

        # inform generic settings module the instance type
        settings._instanceType = "client";

        # set waywall stuff
        waywall = {
          package = pkgs.waywall;
        };
      }

      # Fast asset download
      (lib.mkIf config.enableFastAssetDownload {
        assetHash = lib.mkOptionDefault lib.fakeHash;
      })

      # If nvidiaOffload is enabled
      (lib.mkIf config.enableNvidiaOffload {
        settings.envVars = {
          __NV_PRIME_RENDER_OFFLOAD = "1";
          __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          __VK_LAYER_NV_optimus = "NVIDIA_only";
        };
      })

      # Set values from fabricLoader
      (lib.mkIf (config.settings.fabricLoader.enable) {
        _classSettings.mainClass = config.settings.fabricLoader.meta.clientMainClass;
      })

      # If waywall is enabled
      (lib.mkIf config.waywall.enable {
        # waywall uses custom libglfw.so
        settings.java.extraArguments = [
          "-Dorg.lwjgl.glfw.libname=${inputs.self.packages.${system}.glfw3-waywall}/lib/libglfw.so"
        ];
      })

      # if account is set
      (lib.mkIf (config.account
        != null) {
        _classSettings.uuid = lib.mkIf (config.account.uuid != null) config.account.uuid;
        _classSettings.username = lib.mkIf (config.account.username != null) config.account.username;
      })
    ];
  }
