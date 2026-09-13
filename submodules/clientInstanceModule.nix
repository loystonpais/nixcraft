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

      lwjgl = {
        version = lib.mkOption {
          type = with lib.types; nullOr lib.nixcraft.types.lwjglVersion;
          default = null;
        };
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
              (
                let
                  cond = config._classSettings.assetsDir != null;
                in
                  (optional cond "--assetsDir") ++ (optional cond "${config._classSettings.assetsDir}")
              )

              (
                let
                  cond = config._classSettings.assetIndex != null;
                in
                  (optional cond "--assetIndex") ++ (optional cond config._classSettings.assetIndex)
              )

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
                type = lib.types.nullOr lib.types.path;
                default = null;
              };

              assetIndex = lib.mkOption {
                type = lib.types.nullOr lib.types.nonEmptyStr;
                default = null;
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
          gameDir = lib.mkDefault config.absoluteDir;
        };
      }

      (let
        assets = config.meta.versionData.assets;
        isPre1-6 = assets == "pre-1.6";
        isLegacy = assets == "legacy";
        isModern = !isPre1-6 && !isLegacy;

        assetsDir = mkAssetsDir {
          versionData = config.meta.versionData;
          hash = config.assetHash;
          useFetchAssetsPy = config.enableFastAssetDownload;
          useExternalAssetsDir = config.enableExternalAssets;
          externalAssetsDir = config.externalAssetsDir;
        };
      in
        lib.mkMerge [
          (lib.mkIf isModern {
            _classSettings.assetsDir = lib.mkDefault assetsDir;
            _classSettings.assetIndex = lib.mkDefault assets;
          })

          (lib.mkIf isLegacy {
            _classSettings.assetsDir = lib.mkDefault assetsDir;
          })

          (lib.mkIf isPre1-6 {
            files."resources" = {
              source = assetsDir;
              method = "symlink";
            };
          })
        ])

      {
        libraries =
          lib.nixcraft.maven.mkNormalizedMinecraftLibraryAttrs
          pkgs.stdenv.hostPlatform
          fetchSha1
          config.meta.versionData.libraries;

        mainJar = lib.mkDefault (fetchSha1 config.meta.versionData.downloads.client);

        # Set java.library.path to the native lib dir only if there are any native libraries
        java.D."java.library.path" =
          lib.mkIf (lib.any (l: l.enable && l.native) (lib.attrValues config.libraries))
          (mkNativeLibDir {normalizedLibraries = config.libraries;});

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
        libraries =
          lib.nixcraft.maven.mkNormalizedMinecraftLibraryAttrs
          pkgs.stdenv.hostPlatform
          fetchSha1
          config.forgeLoader.parsedForgeLoader.versionLibraries;
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

      # Darwin-specific version range patches
      (with lib.nixcraft.minecraftVersion;
        lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (lib.mkMerge [
          # 1. Minecraft < 1.13: LWJGL 2 Apple Silicon ARM64 backport
          (lib.mkIf (ls config.version "1.13") {
            lwjgl.version = lib.mkDefault "2.9.4-nightly-20150209";
          })

          # 2. Minecraft 1.13 to 1.18.2 (< 1.19): LWJGL 3.2.2 (ARM64 natives + no-op window icon)
          (lib.mkIf ((grEq config.version "1.13") && (ls config.version "1.19")) {
            lwjgl.version = lib.mkDefault "3.2.2";
          })

          # 3. Minecraft 1.17 to 1.20.1: JNA buffer truncation crash fix (JNA < 5.13.0)
          (lib.mkIf ((grEq config.version "1.17") && (lsEq config.version "1.20.1")) (let
            jnaLibs = {
              "net.java.dev.jna:jna:5.13.0" = {
                enable = lib.mkDefault true;
                native = false;
                relativePath = "net/java/dev/jna/jna/5.13.0/jna-5.13.0.jar";
                jar = fetchSha1 {
                  sha1 = "1200e7ebeedbe0d10062093f32925a912020e747";
                  url = "https://libraries.minecraft.net/net/java/dev/jna/jna/5.13.0/jna-5.13.0.jar";
                };
              };
              "net.java.dev.jna:jna-platform:5.13.0" = {
                enable = lib.mkDefault true;
                native = false;
                relativePath = "net/java/dev/jna/jna-platform/5.13.0/jna-platform-5.13.0.jar";
                jar = fetchSha1 {
                  sha1 = "88e9a306715e9379f3122415ef4ae759a352640d";
                  url = "https://libraries.minecraft.net/net/java/dev/jna/jna-platform/5.13.0/jna-platform-5.13.0.jar";
                };
              };
            };

            stockJnaLibraries =
              lib.filterAttrs
              (name: _: lib.hasPrefix "net.java.dev.jna:" name && !(jnaLibs ? ${name}))
              (lib.nixcraft.maven.mkNormalizedMinecraftLibraryAttrs
                pkgs.stdenv.hostPlatform
                fetchSha1
                config.meta.versionData.libraries);

            disabledStockJnaLibraries =
              lib.mapAttrs (_: _: {
                enable = lib.mkForce false;
              })
              stockJnaLibraries;
          in {
            libraries = disabledStockJnaLibraries // jnaLibs;
          }))
        ]))

      (lib.mkIf (config.account != null && config.account.offline) {
        _classSettings.uuid = lib.mkIf (config.account.uuid != null) config.account.uuid;
        _classSettings.username = lib.mkIf (config.account.username != null) config.account.username;
      })

      # Set custom lwjgl libraries if lwjgl.version is set, and disable stock lwjgl libraries
      (lib.mkIf (config.lwjgl.version != null) (let
        isLwjglLib = name:
          lib.hasPrefix "org.lwjgl:" name
          || lib.hasPrefix "org.lwjgl.lwjgl:" name
          || lib.hasPrefix "net.java.jinput:" name
          || lib.hasPrefix "net.java.jutils:" name;

        stockLibraries =
          lib.nixcraft.maven.mkNormalizedMinecraftLibraryAttrs
          pkgs.stdenv.hostPlatform
          fetchSha1
          config.meta.versionData.libraries;

        customLwjglLibraries =
          lib.nixcraft.maven.mkNormalizedMinecraftLibraryAttrs
          pkgs.stdenv.hostPlatform
          fetchSha1
          sources.lwjgl.${config.lwjgl.version}.libraries;

        forcedCustomLwjglLibraries = lib.mapAttrs (_: l:
          l
          // {
            enable = lib.mkForce l.enable;
          })
        customLwjglLibraries;

        stockLwjglLibraries =
          lib.filterAttrs
          (name: _: isLwjglLib name && !(customLwjglLibraries ? ${name}))
          stockLibraries;

        disabledStockLwjglLibraries =
          lib.mapAttrs (_: _: {
            enable = lib.mkForce false;
          })
          stockLwjglLibraries;
      in {
        libraries = disabledStockLwjglLibraries // forcedCustomLwjglLibraries;
      }))

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
