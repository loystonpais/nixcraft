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
        finalLaunchShellCommandString =
          let
            authDir = "${config.absoluteDir}/.nixcraft/auth";
            accessTokenPath =
              if (config.account != null && config.account.refreshTokenPath != null)
              then "${authDir}/minecraft-access-token"
              else pkgs.writeText "dummy" "dummy";
            profilePath = "${authDir}/minecraft-profile.json";

            dynamicProfileArgs =
              lib.optionals
              (config.account != null && config.account.refreshTokenPath != null)
              [
                ''--username "$(${pkgs.jq}/bin/jq -er '.name' < ${escapeShellArg profilePath})"''
                ''--uuid "$(${pkgs.jq}/bin/jq -er '.id' < ${escapeShellArg profilePath})"''
              ];
          in
            concatStringsSep " " (
              [
                ''"${config.java.package}/bin/java"''
                config.java.finalArgumentShellString
                config.finalArgumentShellString
              ]
              ++ dynamicProfileArgs
              ++ [
                # unmodded client doesn't launch if access token is not provided
                ''--accessToken "$(${pkgs.coreutils}/bin/cat ${escapeShellArg accessTokenPath})"''
              ]
            );

        finalLaunchShellScript = let
          defaultScript = ''
            #!${pkgs.bash}/bin/bash

            set -e

            ${lib.nixcraft.mkExportedEnvVars config.envVars}

            ${config.finalPreLaunchShellScript}

            cd ${escapeShellArg config.absoluteDir}

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

      (lib.mkIf (config.account != null && config.account.refreshTokenPath != null) (
        let
          authDir = "${config.absoluteDir}/.nixcraft/auth";
          accessTokenPath = "${authDir}/minecraft-access-token";
          profilePath = "${authDir}/minecraft-profile.json";
          refreshScript = pkgs.writeShellScript "nixcraft-refresh-token-${name}" ''
            #!${pkgs.bash}/bin/bash

            set -euo pipefail

            refresh_token_path=${escapeShellArg config.account.refreshTokenPath}
            access_token_path=${escapeShellArg accessTokenPath}
            profile_path=${escapeShellArg profilePath}
            # Temporary hack: reuse Prism Launcher's public client id for Microsoft auth.
            client_id='c36a9fb6-4f2a-41ff-90bd-ae7cc92031eb'
            token_endpoint='https://login.microsoftonline.com/consumers/oauth2/v2.0/token'

            mkdir -p \
              "$(${pkgs.coreutils}/bin/dirname "$refresh_token_path")" \
              "$(${pkgs.coreutils}/bin/dirname "$access_token_path")" \
              "$(${pkgs.coreutils}/bin/dirname "$profile_path")"

            refresh_tmp="$(${pkgs.coreutils}/bin/mktemp "$(${pkgs.coreutils}/bin/dirname "$refresh_token_path")/.refresh-token.XXXXXX")"
            access_tmp="$(${pkgs.coreutils}/bin/mktemp "$(${pkgs.coreutils}/bin/dirname "$access_token_path")/.access-token.XXXXXX")"
            profile_tmp="$(${pkgs.coreutils}/bin/mktemp "$(${pkgs.coreutils}/bin/dirname "$profile_path")/.profile.XXXXXX")"
            cleanup() {
              rm -f "$refresh_tmp" "$access_tmp" "$profile_tmp"
            }
            trap cleanup EXIT

            refresh_token="$(${pkgs.coreutils}/bin/tr -d '\r\n' < "$refresh_token_path")"

            microsoft_response="$(
              ${pkgs.curl}/bin/curl \
                --silent \
                --show-error \
                --fail-with-body \
                --request POST \
                --url "$token_endpoint" \
                --header "Content-Type: application/x-www-form-urlencoded" \
                --data-urlencode "client_id=$client_id" \
                --data-urlencode "refresh_token=$refresh_token" \
                --data-urlencode "grant_type=refresh_token"
            )"

            microsoft_access_token="$(printf '%s' "$microsoft_response" | ${pkgs.jq}/bin/jq -er '.access_token')"
            next_refresh_token="$(printf '%s' "$microsoft_response" | ${pkgs.jq}/bin/jq -er '.refresh_token')"

            xbl_payload="$(
              ${pkgs.jq}/bin/jq -cn --arg token "$microsoft_access_token" '{
                Properties: {
                  AuthMethod: "RPS",
                  SiteName: "user.auth.xboxlive.com",
                  RpsTicket: ("d=" + $token)
                },
                RelyingParty: "http://auth.xboxlive.com",
                TokenType: "JWT"
              }'
            )"

            xbl_response="$(
              ${pkgs.curl}/bin/curl \
                --silent \
                --show-error \
                --fail-with-body \
                --request POST \
                --url "https://user.auth.xboxlive.com/user/authenticate" \
                --header "Accept: application/json" \
                --header "Content-Type: application/json" \
                --data "$xbl_payload"
            )"

            xbl_token="$(printf '%s' "$xbl_response" | ${pkgs.jq}/bin/jq -er '.Token')"
            user_hash="$(printf '%s' "$xbl_response" | ${pkgs.jq}/bin/jq -er '.DisplayClaims.xui[0].uhs')"

            xsts_payload="$(
              ${pkgs.jq}/bin/jq -cn --arg token "$xbl_token" '{
                Properties: {
                  SandboxId: "RETAIL",
                  UserTokens: [$token]
                },
                RelyingParty: "rp://api.minecraftservices.com/",
                TokenType: "JWT"
              }'
            )"

            xsts_response="$(
              ${pkgs.curl}/bin/curl \
                --silent \
                --show-error \
                --fail-with-body \
                --request POST \
                --url "https://xsts.auth.xboxlive.com/xsts/authorize" \
                --header "Accept: application/json" \
                --header "Content-Type: application/json" \
                --data "$xsts_payload"
            )"

            xsts_token="$(printf '%s' "$xsts_response" | ${pkgs.jq}/bin/jq -er '.Token')"

            minecraft_payload="$(
              ${pkgs.jq}/bin/jq -cn --arg userHash "$user_hash" --arg token "$xsts_token" '{
                identityToken: ("XBL3.0 x=" + $userHash + ";" + $token)
              }'
            )"

            minecraft_response="$(
              ${pkgs.curl}/bin/curl \
                --silent \
                --show-error \
                --fail-with-body \
                --request POST \
                --url "https://api.minecraftservices.com/authentication/login_with_xbox" \
                --header "Accept: application/json" \
                --header "Content-Type: application/json" \
                --data "$minecraft_payload"
            )"

            minecraft_access_token="$(printf '%s' "$minecraft_response" | ${pkgs.jq}/bin/jq -er '.access_token')"

            minecraft_profile="$(
              ${pkgs.curl}/bin/curl \
                --silent \
                --show-error \
                --fail-with-body \
                --request GET \
                --url "https://api.minecraftservices.com/minecraft/profile" \
                --header "Authorization: Bearer $minecraft_access_token"
            )"

            printf '%s' "$minecraft_profile" | ${pkgs.jq}/bin/jq -er '.id' > /dev/null
            printf '%s' "$minecraft_profile" | ${pkgs.jq}/bin/jq -er '.name' > /dev/null

            printf '%s' "$next_refresh_token" > "$refresh_tmp"
            chmod 600 "$refresh_tmp"
            printf '%s' "$minecraft_access_token" > "$access_tmp"
            chmod 600 "$access_tmp"
            printf '%s\n' "$minecraft_profile" > "$profile_tmp"
            chmod 600 "$profile_tmp"

            ${pkgs.coreutils}/bin/mv "$refresh_tmp" "$refresh_token_path"
            ${pkgs.coreutils}/bin/mv "$access_tmp" "$access_token_path"
            ${pkgs.coreutils}/bin/mv "$profile_tmp" "$profile_path"
          '';
        in {
          preLaunchShellScript = lib.mkBefore ''
            ${refreshScript}
          '';
        }
      ))

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

      (lib.mkIf (config.account != null && config.account.refreshTokenPath == null) {
        _classSettings.uuid = lib.mkIf (config.account.uuid != null) config.account.uuid;
        _classSettings.username = lib.mkIf (config.account.username != null) config.account.username;
      })
    ];
  }
