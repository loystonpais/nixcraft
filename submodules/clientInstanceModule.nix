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
    instanceDirPrefix,
    rootDir,
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
        type = lib.types.nonEmptyStr;
      };

      desktopEntry = lib.mkOption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "desktop entry";
            name = lib.mkOption {
              type = lib.types.nonEmptyStr;
              default = "Nixcraft Instance ${config.name}";
            };
            extraConfig = lib.mkOption {
              type = lib.types.attrs;
              default = {};
            };
          };
        };
        default = {
          enable = false;
        };
      };

      account = lib.mkOption {
        type = with lib.types; nullOr (submodule minecraftAccountModule);
      };

      extraArguments = lib.mkOption {
        type = with lib.types; listOf nonEmptyStr;
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
                cond = config._classSettings.userProperties != null;
              in
                (optional cond "--userProperties") ++ (optional cond (builtins.toJSON config._classSettings.userProperties))
            )

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
                type = lib.types.nonEmptyStr;
              };

              version = lib.mkOption {
                type = lib.types.nonEmptyStr;
              };

              assetsDir = lib.mkOption {
                type = lib.types.path;
              };

              assetIndex = lib.mkOption {
                type = lib.types.nonEmptyStr;
              };

              userProperties = lib.mkOption {
                type = lib.types.nullOr lib.types.attrs;
                default = null;
              };

              gameDir = lib.mkOption {
                type = lib.types.nullOr lib.types.nonEmptyStr;
                default = null;
              };

              username = lib.mkOption {
                type = lib.types.nullOr lib.types.nonEmptyStr;
                default = null;
              };

              uuid = lib.mkOption {
                type = lib.types.nullOr lib.types.nonEmptyStr;
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
        finalLaunchShellCommandString = concatStringsSep " " [
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

        finalLaunchShellScript = let
          defaultScript = ''
            #!${pkgs.bash}/bin/bash

            set -e

            ${lib.nixcraft.mkExportedEnvVars config.envVars}

            ${config.finalPreLaunchShellScript}

            cd "${config.absoluteDir}"

            exec ${config.finalLaunchShellCommandString} "$@"
          '';
        in
          if config.waywall.enable
          then ''
            #!${pkgs.bash}/bin/bash

            set -e

            exec "${config.waywall.package}/bin/waywall" wrap -- "${pkgs.writeTextFile
              {
                name = "run";
                text = defaultScript;
                executable = true;
              }}" "$@"
          ''
          else defaultScript;

        finalActivationShellScript = ''
          ${config.activationShellScript}
        '';

        finalPreLaunchShellScript = ''
          ${config.preLaunchShellScript}
        '';

        dir = lib.mkDefault "${instanceDirPrefix}/${config.name}";
        absoluteDir = "${rootDir}/${config.dir}";

        # set waywall stuff
        waywall = {
          package = pkgs.waywall;
        };
      }

      {
        _classSettings = {
          mainClass = lib.mkDefault config.meta.versionData.mainClass;
          version = lib.mkOptionDefault config.meta.versionData.id;
          assetIndex = config.meta.versionData.assets;
          assetsDir =
            if config.enableFastAssetDownload
            then
              (mkAssetsDir {
                versionData = config.meta.versionData;
                hash = config.assetHash;
                useAria2c = config.enableFastAssetDownload;
              })
            else mkAssetsDir {versionData = config.meta.versionData;};

          gameDir = lib.mkDefault config.absoluteDir;
        };

        libraries = config.meta.versionData.libraries;

        mainJar = lib.mkDefault (fetchSha1 config.meta.versionData.downloads.client);

        # TODO: in javaSettingsModule try to implement this as an actual option
        java.extraArguments = ["-Djava.library.path=${mkNativeLibDir {versionData = config.meta.versionData;}}"];

        # Default libs copied over from
        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/pr/prismlauncher/package.nix#L78
        runtimeLibs = with pkgs;
        with xorg; [
          (lib.getLib stdenv.cc.cc)
          ## native versions
          glfw3-minecraft
          openal

          ## openal
          alsa-lib
          libjack2
          libpulseaudio
          pipewire

          ## glfw
          libGL
          libX11
          libXcursor
          libXext
          libXrandr
          libXxf86vm

          udev # oshi

          vulkan-loader # VulkanMod's lwjgl

          flite # TTS
        ];

        runtimePrograms = with pkgs;
        with xorg; [
          xrandr # This is needed for 1.12.x versions to not crash
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

      (lib.mkIf config.forgeLoader.enable {
        _classSettings.mainClass = "net.minecraftforge.bootstrap.ForgeBootstrap";
        _classSettings.version = config.forgeLoader.parsedForgeLoader.versionId;
        extraArguments = ["--launchTarget" "forge_client"];
        mainJar = let installDir = config.forgeLoader.parsedForgeLoader.clientInstallDirWithClientJar (fetchSha1 config.meta.versionData.downloads.client); in "${installDir}/libraries/net/minecraftforge/forge/${config.forgeLoader.minecraftVersion}-${config.forgeLoader.version}/forge-${config.forgeLoader.minecraftVersion}-${config.forgeLoader.version}-client.jar";
        libraries = config.forgeLoader.parsedForgeLoader.versionLibraries;
      })

      (lib.mkIf config.fabricLoader.enable {
        _classSettings.mainClass = config.fabricLoader.meta.clientMainClass;
      })

      (lib.mkIf config.quiltLoader.enable {
        _classSettings.mainClass = config.quiltLoader.meta.lock.mainClass.client;
      })

      (lib.mkIf config.waywall.enable {
        # waywall uses custom libglfw.so
        java.extraArguments = [
          "-Dorg.lwjgl.glfw.libname=${inputs.self.packages.${system}.glfw3-waywall}/lib/libglfw.so"
        ];
      })

      # If version >= 1.6 && version <= 1.12
      (with lib.nixcraft.minecraftVersion;
        lib.mkIf ((grEq config.version "1.6") && (lsEq config.version "1.12"))
        {
          # Fixes versions crashing without userProperties
          _classSettings.userProperties = lib.mkDefault {};
        })

      (lib.mkIf (config.account
        != null) {
        _classSettings.uuid = lib.mkIf (config.account.uuid != null) config.account.uuid;
        _classSettings.username = lib.mkIf (config.account.username != null) config.account.username;
      })
    ];
  }
