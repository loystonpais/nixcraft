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

      enableDriPrime = lib.mkEnableOption "dri prime (mesa)";

      useDiscreteGPU =
        (lib.mkEnableOption "discrete GPU")
        // {
          default = true;
        };

      # Hide these two option for now
      enableFastAssetDownload =
        (lib.mkEnableOption "fast asset downloading using aria2c (hash needs to be provided)")
        // {
          internal = true;
        };

      assetHash = lib.mkOption {
        type = lib.types.nonEmptyStr;
        internal = true;
      };

      desktopEntry = lib.mkOption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "desktop entry";
            name = lib.mkOption {
              type = lib.types.nonEmptyStr;
              default = "Nixcraft Instance ${name}";
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
        default = null;
      };

      saves = lib.mkOption {
        type = lib.types.attrsOf (lib.types.path);
        default = {};
        description = ''
          World saves. Placed only if the directory already doesn't exist
          {
            "My World" = /path/to/world
          }
        '';
      };

      extraArguments = lib.mkOption {
        type = with lib.types; listOf nonEmptyStr;
        default = [];
      };

      finalArgumentShellString = lib.mkOption {
        type = with lib.types; nonEmptyStr;
        readOnly = true;
        default = with lib;
          escapeShellArgs (
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
            ]
          );
      };

      _classSettings = lib.mkOption {
        type = with lib.types;
          submodule {
            options = {
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
          config.java.finalArgumentShellString
          config.finalArgumentShellString

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
          then
            (let
              configDirStr = lib.optionalString (config.waywall.configDir != null) "XDG_CONFIG_HOME=${(pkgs.linkFarm "waywall-config-dir" {
                waywall = config.waywall.configDir;
              })}";

              configTextStr = lib.optionalString (config.waywall.configText != null) "XDG_CONFIG_HOME=${(pkgs.linkFarm "waywall-config-dir" {
                "waywall/init.lua" = pkgs.writeTextFile {
                  name = "init.lua";
                  text = config.waywall.configText;
                };
              })}";

              profileStr = lib.optionalString (config.waywall.profile != null) "--profile ${lib.escapeShellArg config.waywall.profile}";

              runScript =
                pkgs.writeTextFile
                {
                  name = "run";
                  text = defaultScript;
                  executable = true;
                };
            in ''
              #!${pkgs.bash}/bin/bash

              set -e

              ${configDirStr} ${configTextStr} exec "${config.waywall.package}/bin/waywall" wrap ${profileStr} -- "${runScript}" "$@"
            '')
          else defaultScript;

        finalActivationShellScript = ''
          ${config.activationShellScript}
        '';

        finalPreLaunchShellScript = ''
          ${config.preLaunchShellScript}
        '';

        # set waywall stuff
        waywall = {
          package = pkgs.waywall;
        };
      }

      # Place saves
      {
        preLaunchShellScript = let
          absSavesPath = "${config.absoluteDir}/saves";

          placeSaves =
            lib.concatMapAttrsStringSep "\n" (name: path: let
              absPlacePath = "${config.absoluteDir}/saves/${name}";
            in ''
              if [ ! -d ${escapeShellArg absPlacePath} ]; then
                rm -rf ${escapeShellArg absPlacePath}
                cp -R ${escapeShellArg path} ${escapeShellArg absPlacePath}
                chmod -R u+w ${escapeShellArg absPlacePath}
              fi
            '')
            config.saves;
        in ''
          if [ ! -d ${escapeShellArg absSavesPath} ]; then
            rm -f ${escapeShellArg absSavesPath}
            mkdir -p ${escapeShellArg absSavesPath}
            chmod -R u+w ${escapeShellArg absSavesPath} || true
          fi

          ${placeSaves}
        '';
      }

      {
        _classSettings = {
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

        java.mainClass = lib.mkDefault config.meta.versionData.mainClass;

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

          libxtst
          libxkbcommon
          libxt
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

      (lib.mkIf config.enableDriPrime {
        envVars = {
          DRI_PRIME = "1";
        };
      })

      (lib.mkIf config.useDiscreteGPU {
        enableDriPrime = true;
        enableNvidiaOffload = true;
      })

      (lib.mkIf config.fixBugs (lib.mkMerge [
        (lib.mkIf config.enableNvidiaOffload {
          # Prevents minecraft from segfaulting on exit
          envVars.__GL_THREADED_OPTIMIZATIONS = "0";
        })
      ]))

      (lib.mkIf config.forgeLoader.enable {
        java.mainClass = "net.minecraftforge.bootstrap.ForgeBootstrap";
        _classSettings.version = config.forgeLoader.parsedForgeLoader.versionId;
        extraArguments = ["--launchTarget" "forge_client"];
        mainJar = let installDir = config.forgeLoader.parsedForgeLoader.clientInstallDirWithClientJar (fetchSha1 config.meta.versionData.downloads.client); in "${installDir}/libraries/net/minecraftforge/forge/${config.forgeLoader.minecraftVersion}-${config.forgeLoader.version}/forge-${config.forgeLoader.minecraftVersion}-${config.forgeLoader.version}-client.jar";
        libraries = config.forgeLoader.parsedForgeLoader.versionLibraries;
      })

      (lib.mkIf config.fabricLoader.enable {
        java.mainClass = config.fabricLoader.meta.clientMainClass;
      })

      (lib.mkIf config.quiltLoader.enable {
        java.mainClass = config.quiltLoader.meta.lock.mainClass.client;
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
