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
in
  {
    name,
    config,
    shared ? {},
    authDirPrefix,
    externalAssetsDirPrefix,
    externalAssetsLookupPaths ? [],
    ...
  }: {
    imports = [genericInstanceModule];

    options = {
      enable =
        (lib.mkEnableOption "client instance")
        // {
          default = true;
        };

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
        (lib.mkEnableOption "fast asset downloading using fetchAssetsPy (hash needs to be provided)")
        // {
          internal = true;
        };

      assetHash = lib.mkOption {
        type = lib.types.nonEmptyStr;
        internal = true;
      };

      enableExternalAssets = lib.mkEnableOption "external asset management via fetchAssets script";

      externalAssetsDir = lib.mkOption {
        type = lib.types.nullOr (lib.types.pathWith {absolute = true;});
        default = externalAssetsDirPrefix;
        description = "Path to external assets directory";
      };

      externalAssetsExtraLookupPaths = lib.mkOption {
        type = with lib.types; listOf (oneOf [str path]);
        default = [];
        description = "Extra paths to read/lookup cached assets from when fetching external assets.";
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
        type = with lib.types;
          nullOr (submodule [
            minecraftAccountModule
            ({lib, ...}: {
              options.authDir = lib.mkOption {
                type = lib.types.str;
                default = authDirPrefix;
                description = "Path to nixcraft auth cache directory.";
              };
            })
          ]);
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

      enableNixGL = lib.mkEnableOption "nixGL";

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
              (optionals (config.meta.versionData.assets != "legacy") [
                "--assetIndex"
                config._classSettings.assetIndex
              ])

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
        ];

        finalLaunchShellScript = let
          authPkg = pkgs.callPackage ../packages/client-auth {};
          acc = config.account;

          authArgsScript = let
            uuidArg = lib.optionalString (acc.uuid != null) "--uuid ${escapeShellArg acc.uuid}";
            verifyUsernameArg = lib.optionalString (acc.username != null) "--verify-username ${escapeShellArg acc.username}";
          in
            if acc != null && !acc.offline
            then ''AUTH=$(${lib.getExe authPkg} --auth-dir ${escapeShellArg acc.authDir} auth ${uuidArg} ${verifyUsernameArg} --as-client-args)''
            else ''AUTH="--accessToken dummy"'';

          defaultScript = ''
            #!${pkgs.bash}/bin/bash

            set -e

            ${lib.nixcraft.mkExportedEnvVars config.envVars}

            ${config.finalPreLaunchShellScript}

            cd ${escapeShellArg config.absoluteDir}

            ${authArgsScript}

            exec ${config.finalLaunchShellCommandString} $AUTH "$@"
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
        files =
          lib.mapAttrs' (
            name: path:
              lib.nameValuePair "saves/${name}" {
                source = path;
                method = "world";
              }
          )
          config.saves;
      }

      {
        _classSettings = {
          version = lib.mkOptionDefault config.meta.versionData.id;
          assetIndex = config.meta.versionData.assets;
          assetsDir = lib.mkDefault (mkAssetsDir {
            versionData = config.meta.versionData;
            hash = config.assetHash;
            useFetchAssetsPy = config.enableFastAssetDownload;
            useExternalAssetsDir = config.enableExternalAssets;
            externalAssetsDir = config.externalAssetsDir;
          });

          gameDir = lib.mkDefault config.absoluteDir;
        };

        libraries = config.meta.versionData.libraries;

        mainJar = lib.mkDefault (fetchSha1 config.meta.versionData.downloads.client);

        java.D."java.library.path" = mkNativeLibDir {versionData = config.meta.versionData;};
        java.extraArguments = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
          "-XstartOnFirstThread"
        ];

        java.mainClass = lib.mkDefault config.meta.versionData.mainClass;

        # Default libs copied over from
        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/pr/prismlauncher/package.nix#L78
        runtimeLibs = with pkgs;
          [
            (lib.getLib stdenv.cc.cc)
            openal
            vulkan-loader # VulkanMod's lwjgl
            flite # TTS
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            ## openal
            alsa-lib
            libjack2
            libpulseaudio
            pipewire

            ## glfw
            glfw3-minecraft
            libGL

            libx11
            libxcursor
            libxext
            libxrandr
            libxxf86vm
            udev # oshi
            libxtst
            libxkbcommon
            libxt
          ];

        runtimePrograms = with pkgs;
          lib.optionals stdenv.hostPlatform.isLinux [
            xrandr # This is needed for 1.12.x versions to not crash
          ];

        # inform generic settings module the instance type
        _instanceType = "client";
      }

      (let
        inherit (pkgs) mesa libglvnd libvdpau-va-gl;

        mesa-drivers = [
          mesa
        ];

        libvdpau = [libvdpau-va-gl];

        glxindirect = pkgs.runCommandLocal "mesa_glxindirect" {} ''
          mkdir -p $out/lib
          ln -s ${mesa}/lib/libGLX_mesa.so.0 $out/lib/libGLX_indirect.so.0
        '';
      in
        lib.mkIf config.enableNixGL {
          envVars = {
            GBM_BACKENDS_PATH = lib.makeSearchPathOutput "lib" "lib/gbm" mesa-drivers;
            LIBGL_DRIVERS_PATH = lib.makeSearchPathOutput "lib" "lib/dri" mesa-drivers;
            LIBVA_DRIVERS_PATH = lib.makeSearchPathOutput "out" "lib/dri" mesa-drivers;
          };

          runtimeLibs = mesa-drivers ++ [glxindirect libglvnd];
          envVars.LD_LIBRARY_PATH = [
            (lib.makeSearchPathOutput "lib" "lib/vdpau" libvdpau)
          ];
        })

      (lib.mkIf config.enableExternalAssets {
        preLaunchShellScript = let
          indexFile = fetchSha1 config.meta.versionData.assetIndex;
          allLookupDirs =
            config.externalAssetsExtraLookupPaths ++ externalAssetsLookupPaths;
          dirsArg = lib.concatMapStringsSep " " lib.escapeShellArg allLookupDirs;
        in ''
          mkdir -p ${lib.escapeShellArg config.externalAssetsDir}
          ${pkgs.python3}/bin/python3 ${../scripts/client-fetch-assets.py} \
            --index ${indexFile} \
            --out-dir ${lib.escapeShellArg config.externalAssetsDir} \
            --read-cache-dirs ${dirsArg}
        '';
      })

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

      (lib.mkIf config.mrpack.enable {
        saves = config.mrpack._parsedMrpack.saves.overrides-plus-client-overrides;
      })

      (lib.mkIf config.waywall.enable {
        # waywall uses custom libglfw.so
        java.D."org.lwjgl.glfw.libname" = "${inputs.self.packages.${system}.glfw3-waywall}/lib/libglfw.so";
      })

      # If version >= 1.6 && version <= 1.12
      (with lib.nixcraft.minecraftVersion;
        lib.mkIf ((grEq config.version "1.6") && (lsEq config.version "1.12"))
        {
          # Fixes versions crashing without userProperties
          _classSettings.userProperties = lib.mkDefault {};
        })

      (lib.mkIf (config.account != null && config.account.offline) {
        _classSettings.uuid = lib.mkIf (config.account.uuid != null) config.account.uuid;
        _classSettings.username = lib.mkIf (config.account.username != null) config.account.username;
      })

      (let
        prefixMsg = "client instance '${config.name}'";
      in {
        _module.check = lib.all (a: a) [
          (lib.assertMsg
            (!(config.enableFastAssetDownload && config.enableExternalAssets))
            "${prefixMsg}: cannot have both .enableFastAssetDownload and .enableExternalAssets enabled at the same time.")
        ];
      })
    ];
  }
