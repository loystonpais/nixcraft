{
  config,
  lib,
  ...
} @ flakeArgs: {
  nixcraft.client.instance.extensions = [
    ({
      name,
      config,
      pkgs,
      lib,
      ...
    }: let
      defaultGlfw3Waywall = flakeArgs.config.nixcraft.lib.glfw3Waywall.mkPackage pkgs;
    in {
      options = {
        waywall = lib.mkOption {
          type = lib.types.submodule ({config, ...}: {
            options = {
                enable = lib.mkEnableOption "waywall";

                package = lib.mkOption {
                  type = lib.types.package;
                };

                profile = lib.mkOption {
                  type = lib.types.nullOr lib.types.nonEmptyStr;
                  example = "foo";
                  default = null;
                };

                configText = lib.mkOption {
                  type = lib.types.nullOr lib.types.nonEmptyStr;
                  description = ''
                    Lua script passed as init.lua
                  '';
                  default = null;
                };

                configDir = lib.mkOption {
                  type = lib.types.nullOr (lib.types.pathWith {absolute = true;});
                  description = ''
                    Path to a dir containing waywall scripts such as init.lua
                    If not set then $XDG_CONFIG_HOME/waywall is used as usual
                  '';
                  example = ''
                    pkgs.linkFarm {
                      "init.lua" = builtins.toFile "init.lua" "<content>";
                    };
                  '';
                  default = null;
                };

                noEnvReexec = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                };

                extraArguments = lib.mkOption {
                  type = with lib.types; listOf nonEmptyStr;
                  default = [];
                };
              };

              config = lib.mkMerge [
                {
                  package = lib.mkOptionDefault pkgs.waywall;
                }
                (lib.mkIf (config.configText != null) {
                  profile = null;
                })
              ];
            });
          };
        };

        config = lib.mkMerge [
          (lib.mkIf config.waywall.enable (lib.mkMerge [
            {
              # Minecraft >= 26.1 uses bundled GLFW with native Wayland support via debug flags.
              # Older versions require the waywall-patched GLFW library.
              java.D =
                if (flakeArgs.config.nixcraft.lib.minecraftVersion.grEq config.version "26.1")
                then {
                  "MC_DEBUG_ENABLED" = "";
                  "MC_DEBUG_PREFER_WAYLAND" = "";
                }
                else {
                  "org.lwjgl.glfw.libname" = "${defaultGlfw3Waywall}/lib/libglfw.so";
                };

              launchPrefix.waywall = {
                priority = lib.mkDefault 500;
                command = lib.concatLists [
                  [
                    "${config.waywall.package}/bin/waywall"
                    "wrap"
                  ]
                  (lib.optional config.waywall.noEnvReexec "--no-env-reexec")
                  (lib.optionals (config.waywall.profile != null) [
                    "--profile"
                    config.waywall.profile
                  ])
                  config.waywall.extraArguments
                ];
                separator = "--";
                envVars =
                  lib.optionalAttrs (config.waywall.configDir != null) {
                    XDG_CONFIG_HOME = pkgs.linkFarm "waywall-config-dir" {
                      waywall = config.waywall.configDir;
                    };
                  }
                  // lib.optionalAttrs (config.waywall.configText != null) {
                    XDG_CONFIG_HOME = pkgs.linkFarm "waywall-config-dir" {
                      "waywall/init.lua" = pkgs.writeTextFile {
                        name = "init.lua";
                        text = config.waywall.configText;
                      };
                    };
                  };
              };
            }
          ]))

          # Validations
          {
            _module.check = lib.all (a: a) [
              (
                lib.assertMsg
                ((lib.count (v: v != null) [
                    config.waywall.configDir
                    config.waywall.configText
                  ])
                  <= 1) "either .configText or .configDir needs to be set not both"
              )
            ];
          }
        ];
      })
    ];
}
