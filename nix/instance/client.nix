{
  config,
  lib,
  ...
} @ flakeArgs: let
  inherit (config.nixcraft) sources;
in {
  nixcraft.client.instance.module = {
    name,
    config,
    shared ? {},
    authDirPrefix ? "/tmp/nixcraft-client-auth",
    externalAssetsDirPrefix ? "/tmp/nixcraft-client-assets",
    skinsDirPrefix ? "/tmp/nixcraft-client-skins",
    externalAssetsLookupPaths ? [],
    pkgs,
    ...
  }: {
    imports = [
      flakeArgs.config.nixcraft.instance.module
    ] ++ flakeArgs.config.nixcraft.client.instance.extensions;

    options = {
        enable =
          (lib.mkEnableOption "client instance")
          // {
            default = true;
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
            type = with lib.types; nullOr (either (enum ["latest"]) flakeArgs.config.nixcraft.lib.types.lwjglVersion);
            default = null;
            apply = v:
              if v == "latest"
              then builtins.head sources.lwjgl.versions
              else v;
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

        enableExternalAssets =
          (lib.mkEnableOption "external asset management via fetchAssets script")
          // {
            default = true;
          };

        externalAssetsDir = lib.mkOption {
          type = lib.types.nullOr (lib.types.pathWith {absolute = true;});
          default = externalAssetsDirPrefix;
          description = "Path to external assets directory";
        };

        skinsDir = lib.mkOption {
          type = lib.types.nullOr (lib.types.pathWith {absolute = true;});
          default = skinsDirPrefix;
          description = "Path to writable directory where client skins are cached/stored.";
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
            nullOr (submodule {
              options = {
                offline = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Whether this account is offline (unauthenticated).";
                };

                uuid = lib.mkOption {
                  type = lib.types.nullOr lib.types.nonEmptyStr;
                  default = null;
                  description = "Player UUID.";
                };

                username = lib.mkOption {
                  type = lib.types.nullOr lib.types.nonEmptyStr;
                  default = null;
                  description = "Player username. For online accounts, used to verify against authenticated profile.";
                };

                authDir = lib.mkOption {
                  type = lib.types.str;
                  default = authDirPrefix;
                  description = "Path to nixcraft auth cache directory.";
                };
              };
            });
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

        optionsTxt = lib.mkOption {
          type = with lib.types; nullOr (attrsOf anything);
          default = null;
        };

        enableNixGL = lib.mkEnableOption "nixGL";

        enableMangoHud = lib.mkEnableOption "mangohud";

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
          finalLaunchShellCommandString = with lib;
            concatStringsSep " " (concatLists [
              (flakeArgs.config.nixcraft.lib.mkLaunchPrefixList config.launchPrefix)
              [
                ''"${config.java.package}/bin/java"''
                config.java.finalArgumentShellString
                config.finalArgumentShellString
              ]
            ]);

          finalLaunchShellScript = ''
            #!${pkgs.bash}/bin/bash

            set -e

            ${flakeArgs.config.nixcraft.lib.mkExportedEnvVars config.envVars}

            ${config.finalPreLaunchShellScript}

            cd ${lib.escapeShellArg config.absoluteDir}

            exec ${config.finalLaunchShellCommandString} "$@"
          '';

          finalActivationShellScript = ''
            ${config.activationShellScript}
          '';

          finalPreLaunchShellScript = ''
            ${config.preLaunchShellScript}
          '';
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

          assetsDir = flakeArgs.config.nixcraft.lib.builders.mkAssetsDir pkgs {
            versionData = config.meta.versionData;
            hash = config.assetHash;
            skinsDir = config.skinsDir;
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
            lib.mapAttrs
            (_: libDef: lib.mkDefault libDef)
            (flakeArgs.config.nixcraft.lib.maven.mkNormalizedMinecraftLibraryAttrs
              pkgs.stdenv.hostPlatform
              pkgs
              config.meta.versionData.libraries);

          mainJar = lib.mkDefault (pkgs.fetchurl {
            inherit (config.meta.versionData.downloads.client) url sha1;
          });

          # Set java.library.path to the native lib dir only if there are any native libraries
          java.D."java.library.path" =
            lib.mkIf (lib.any (l: l.enable && l.native) (lib.attrValues config.finalLibraries))
            (flakeArgs.config.nixcraft.lib.builders.mkNativeLibDir pkgs {normalizedLibraries = config.finalLibraries;});

          java.mainClass = lib.mkDefault config.meta.versionData.mainClass;

          # Default libs
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
              wayland
              libdecor
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
            clientFetchAssets = flakeArgs.config.nixcraft.lib.clientFetchAssets.mkPackage pkgs;
            indexFile = pkgs.fetchurl {
              inherit (config.meta.versionData.assetIndex) url sha1;
            };
            allLookupDirs =
              config.externalAssetsExtraLookupPaths ++ externalAssetsLookupPaths;
            dirsArg = lib.concatMapStringsSep " " lib.escapeShellArg allLookupDirs;
          in ''
            mkdir -p ${lib.escapeShellArg config.externalAssetsDir}
            ${lib.getExe clientFetchAssets} \
              --index ${indexFile} \
              --out-dir ${lib.escapeShellArg config.externalAssetsDir} \
              --read-cache-dirs ${dirsArg}
          '';
        })

        (lib.mkIf (config.skinsDir != null) {
          preLaunchShellScript = ''
            mkdir -p ${lib.escapeShellArg config.skinsDir}
          '';
        })

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

        (lib.mkIf config.useDiscreteGPU (
          lib.mkMerge [
            (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
              enableDriPrime = true;
              enableNvidiaOffload = true;
            })
          ]
        ))

        (lib.mkIf config.fixBugs (lib.mkMerge [
          (lib.mkIf config.enableNvidiaOffload {
            # Prevents minecraft from segfaulting on exit
            envVars.__GL_THREADED_OPTIMIZATIONS = "0";
          })
        ]))

        (lib.mkIf config.mrpack.enable {
          saves = config.mrpack._parsedMrpack.saves.overrides-plus-client-overrides;
        })

        (lib.mkIf config.enableMangoHud {
          launchPrefix.mangohud = {
            priority = lib.mkDefault 600;
            command = ["${lib.getExe pkgs.mangohud}"];
            separator = null;
          };
        })

        # If version >= 1.6 && version <= 1.12
        (with flakeArgs.config.nixcraft.lib.minecraftVersion;
          lib.mkIf ((grEq config.version "1.6") && (lsEq config.version "1.12"))
          {
            # Fixes versions crashing without userProperties
            _classSettings.userProperties = lib.mkDefault {};
          })

        # Darwin-specific version range patches
        (with flakeArgs.config.nixcraft.lib.minecraftVersion;
          lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (lib.mkMerge [
            # -XstartOnFirstThread is strictly required for GLFW (LWJGL 3 >= 1.13) on macOS,
            # but breaks AWT/Cocoa event dispatch in LWJGL 2 (< 1.13), preventing the window from appearing.
            (lib.mkIf (grEq config.version "1.13") {
              java.extraArguments = ["-XstartOnFirstThread"];
            })

            # 1. Minecraft < 1.13: LWJGL 2 Apple Silicon ARM64 backport
            (lib.mkIf (ls config.version "1.13") {
              lwjgl.version = lib.mkDefault "2.9.4-nightly-20150209";
            })

            # 2. Minecraft 1.13 to 1.18.2 (< 1.19): LWJGL 3.2.2 (ARM64 natives + no-op window icon)
            (lib.mkIf ((grEq config.version "1.13") && (ls config.version "1.19")) {
              lwjgl.version = lib.mkDefault "3.2.2";
            })

            # 3. Minecraft 1.12 to 1.18.2 (< 1.19): Objective-C bridge ARM64 natives
            (lib.mkIf ((grEq config.version "1.12") && (ls config.version "1.19")) (let
              bridgeLibs = {
                "ca.weblite:java-objc-bridge:1.1.0-mmachina.1" = {
                  enable = lib.mkDefault true;
                  native = false;
                  relativePath = "ca/weblite/java-objc-bridge/1.1.0-mmachina.1/java-objc-bridge-1.1.jar";
                  jar = pkgs.fetchurl {
                    sha1 = "369a83621e3c65496348491e533cb97fe5f2f37d";
                    url = "https://github.com/MinecraftMachina/Java-Objective-C-Bridge/releases/download/1.1.0-mmachina.1/java-objc-bridge-1.1.jar";
                  };
                };
              };

              stockBridgeLibraries =
                lib.filterAttrs
                (name: _: lib.hasPrefix "ca.weblite:java-objc-bridge:" name && !(bridgeLibs ? ${name}))
                (flakeArgs.config.nixcraft.lib.maven.mkNormalizedMinecraftLibraryAttrs
                  pkgs.stdenv.hostPlatform
                  pkgs
                  config.meta.versionData.libraries);

              disabledStockBridgeLibraries =
                lib.mapAttrs (_: _: {
                  enable = lib.mkForce false;
                })
                stockBridgeLibraries;
            in {
              libraries = disabledStockBridgeLibraries // bridgeLibs;
            }))

            # 4. Minecraft 1.12 to 1.20.1: JNA ARM64 natives (< 1.17) and buffer truncation crash fix (< 1.20.2)
            (lib.mkIf ((grEq config.version "1.12") && (ls config.version "1.20.2")) (let
              jnaLibs = {
                "net.java.dev.jna:jna:5.13.0" = {
                  enable = lib.mkDefault true;
                  native = false;
                  relativePath = "net/java/dev/jna/jna/5.13.0/jna-5.13.0.jar";
                  jar = pkgs.fetchurl {
                    sha1 = "1200e7ebeedbe0d10062093f32925a912020e747";
                    url = "https://libraries.minecraft.net/net/java/dev/jna/jna/5.13.0/jna-5.13.0.jar";
                  };
                };
                "net.java.dev.jna:jna-platform:5.13.0" = {
                  enable = lib.mkDefault true;
                  native = false;
                  relativePath = "net/java/dev/jna/jna-platform/5.13.0/jna-platform-5.13.0.jar";
                  jar = pkgs.fetchurl {
                    sha1 = "88e9a306715e9379f3122415ef4ae759a352640d";
                    url = "https://libraries.minecraft.net/net/java/dev/jna/jna-platform/5.13.0/jna-platform-5.13.0.jar";
                  };
                };
              };

              stockJnaLibraries =
                lib.filterAttrs
                (name: _: lib.hasPrefix "net.java.dev.jna:" name && !(jnaLibs ? ${name}))
                (flakeArgs.config.nixcraft.lib.maven.mkNormalizedMinecraftLibraryAttrs
                  pkgs.stdenv.hostPlatform
                  pkgs
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

        # Linux ARM64 LWJGL native replacements. Keep these explicit MC-version
        # ranges aligned with LWJGL's version changes and the ARM64 source catalog.
        (with flakeArgs.config.nixcraft.lib.minecraftVersion;
          lib.mkIf
          (pkgs.stdenv.hostPlatform.isLinux && pkgs.stdenv.hostPlatform.isAarch64)
          (lib.mkMerge [
            # LWJGL 3.3.1 has Linux ARM64 natives.
            (lib.mkIf ((grEq config.version "1.19") && (ls config.version "1.20.2")) {
              lwjgl.version = lib.mkDefault "3.3.1";
            })

            # 1.20.2 uses LWJGL 3.3.2, which has no Linux ARM64 component here.
            # LWJGL 3.3.3 (used by 1.21.x) does.
            (lib.mkIf ((grEq config.version "1.21") && (ls config.version "26.1")) {
              lwjgl.version = lib.mkDefault "3.3.3";
            })

            # Minecraft 26.1/26.2 use LWJGL 3.4.1; 26.1.2 is confirmed working.
            (lib.mkIf ((grEq config.version "26.1") && (ls config.version "26.3")) {
              lwjgl.version = lib.mkDefault "3.4.1";
            })

            # Minecraft 26.3 uses LWJGL 3.4.3, with Linux ARM64 natives available.
            (lib.mkIf ((grEq config.version "26.3") && (ls config.version "26.4")) {
              lwjgl.version = lib.mkDefault "3.4.3";
            })
          ]))

        (lib.mkIf (config.account != null) (lib.mkMerge [
          (lib.mkIf config.account.offline {
            _classSettings.uuid = lib.mkIf (config.account.uuid != null) config.account.uuid;
            _classSettings.username = lib.mkIf (config.account.username != null) config.account.username;
            extraArguments = ["--accessToken" "dummy"];
          })

          (lib.mkIf (!config.account.offline) (let
            authPkg = flakeArgs.config.nixcraft.lib.clientAuth.mkPackage pkgs;
            acc = config.account;
          in {
            launchPrefix.auth = {
              priority = lib.mkDefault 50;
              command = lib.concatLists [
                [
                  "${lib.getExe authPkg}"
                  "--auth-dir"
                  acc.authDir
                  "wrap"
                ]
                (lib.optionals (acc.uuid != null) [
                  "--uuid"
                  acc.uuid
                ])
                (lib.optionals (acc.username != null) [
                  "--verify-username"
                  acc.username
                ])
              ];
              separator = "--";
            };
          }))
        ]))

        # Set custom lwjgl libraries if lwjgl.version is set, and disable stock lwjgl libraries
        (lib.mkIf (config.lwjgl.version != null) (let
          isLwjglLib = name:
            lib.hasPrefix "org.lwjgl:" name
            || lib.hasPrefix "org.lwjgl.lwjgl:" name
            || lib.hasPrefix "net.java.jinput:" name
            || lib.hasPrefix "net.java.jutils:" name;

          stockLibraries =
            flakeArgs.config.nixcraft.lib.maven.mkNormalizedMinecraftLibraryAttrs
            pkgs.stdenv.hostPlatform
            pkgs
            config.meta.versionData.libraries;

          customLwjglLibraries =
            flakeArgs.config.nixcraft.lib.maven.mkNormalizedMinecraftLibraryAttrs
            pkgs.stdenv.hostPlatform
            pkgs
            sources.lwjgl.components.${config.lwjgl.version};

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

        (lib.mkIf (config.optionsTxt != null) (let
          dataVersion = sources.mojang.meta.data_versions.${config.version} or null;
        in {
          files."options.txt" = {
            type = "options-txt";
            method = "merge";
            value = lib.mkMerge [
              (lib.mkIf (dataVersion != null) {
                version = lib.mkDefault dataVersion;
              })
              config.optionsTxt
            ];
          };
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
    };
}
