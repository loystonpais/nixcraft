{
  lib,
  sources,
  nixcraft,
  ...
}: let
  inherit
    (builtins)
    readDir
    elem
    mapAttrs
    readFile
    fromJSON
    ;
  inherit
    (lib)
    mapAttrs'
    nameValuePair
    foldl'
    filter
    getAttrs
    mkMerge
    foldAttrs
    mapAttrsToList
    ;
in
  with nixcraft; {
    types = rec {
      minecraftVersion = lib.mkOptionType {
        name = "minecraftVersion";
        description = "Minecraft version";
        check = version:
          lib.assertMsg
          (builtins.hasAttr version sources.mojang.versions)
          "Minecraft version '${version}' does not exist.";
        merge = loc: defs: (lib.head defs).value;
      };

      lwjglVersion = lib.mkOptionType {
        name = "lwjglVersion";
        description = "LWJGL version";
        check = version:
          lib.assertMsg
          (builtins.isString version && (builtins.elem version sources.lwjgl.versions || builtins.hasAttr version sources.lwjgl.components))
          "LWJGL version '${toString version}' does not exist.";
        merge = loc: defs: (lib.head defs).value;
      };

      fabricLoaderVersion = lib.mkOptionType {
        name = "fabricLoaderVersion";
        description = "Fabric loader version";
        check = version:
          lib.assertMsg
          (builtins.isString version && builtins.elem version sources.fabric.versions)
          "Fabric loader version '${toString version}' does not exist.";
        merge = loc: defs: (lib.head defs).value;
      };

      quiltLoaderVersion = lib.mkOptionType {
        name = "quiltLoaderVersion";
        description = "Quilt loader version";
        check = version:
          lib.assertMsg
          (builtins.isString version && builtins.elem version sources.quilt.versions)
          "Quilt loader version '${toString version}' does not exist.";
        merge = loc: defs: (lib.head defs).value;
      };

      forgeLoaderVersion = lib.mkOptionType {
        name = "forgeLoaderVersion";
        description = "Forge loader version";
        check = version:
          lib.assertMsg
          (builtins.isString version && builtins.elem version sources.forge.versions)
          "Forge loader version '${toString version}' does not exist.";
        merge = loc: defs: (lib.head defs).value;
      };

      neoforgeLoaderVersion = lib.mkOptionType {
        name = "neoforgeLoaderVersion";
        description = "NeoForge loader version";
        check = version:
          lib.assertMsg
          (builtins.isString version && builtins.elem version sources.neoforge.versions)
          "NeoForge loader version '${toString version}' does not exist.";
        merge = loc: defs: (lib.head defs).value;
      };

      paperVersion = lib.mkOptionType {
        name = "paperVersion";
        description = "Paper server Minecraft version";
        check = version:
          lib.assertMsg
          (builtins.isString version && builtins.elem version sources.paper.versions)
          "Paper server Minecraft version '${toString version}' does not exist.";
        merge = loc: defs: (lib.head defs).value;
      };

      foliaVersion = lib.mkOptionType {
        name = "foliaVersion";
        description = "Folia server Minecraft version";
        check = version:
          lib.assertMsg
          (builtins.isString version && builtins.elem version sources.folia.versions)
          "Folia server Minecraft version '${toString version}' does not exist.";
        merge = loc: defs: (lib.head defs).value;
      };

      purpurVersion = lib.mkOptionType {
        name = "purpurVersion";
        description = "Purpur server Minecraft version";
        check = version:
          lib.assertMsg
          (builtins.isString version && builtins.elem version sources.purpur.versions)
          "Purpur server Minecraft version '${toString version}' does not exist.";
        merge = loc: defs: (lib.head defs).value;
      };

      velocityVersion = lib.mkOptionType {
        name = "velocityVersion";
        description = "Velocity proxy version";
        check = version:
          lib.assertMsg
          (builtins.isString version && builtins.elem version sources.velocity.versions)
          "Velocity proxy version '${toString version}' does not exist.";
        merge = loc: defs: (lib.head defs).value;
      };

      waterfallVersion = lib.mkOptionType {
        name = "waterfallVersion";
        description = "Waterfall proxy version";
        check = version:
          lib.assertMsg
          (builtins.isString version && builtins.elem version sources.waterfall.versions)
          "Waterfall proxy version '${toString version}' does not exist.";
        merge = loc: defs: (lib.head defs).value;
      };

      javaMemorySize = lib.mkOptionType {
        name = "javaMemorySize";
        description = "Java memory size (in MBs)";
        check = value:
          lib.assertMsg (builtins.isInt value && (value >= 512))
          "Invalid memory size: '${toString value}'. Must be an integer and above 512MBs.";
        merge = loc: defs: (lib.head defs).value;
      };

      libraryModule = {name, ...}: {
        options = {
          enable =
            (lib.mkEnableOption "library ${name}")
            // {
              default = true;
            };

          relativePath = lib.mkOption {
            type = with lib.types; nullOr (pathWith {absolute = false;});
            default = null;
          };

          jar = lib.mkOption {
            type = lib.types.pathWith {absolute = true;};
          };

          native = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
      };

      library = lib.types.submodule libraryModule;
    };
  }
