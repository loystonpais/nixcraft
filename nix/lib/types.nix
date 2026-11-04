{
  config,
  lib,
  ...
}: let
  inherit (config.nixcraft) sources;

  toSet = list: lib.genAttrs list (_: true);
  lwjglVersionSet = toSet sources.lwjgl.versions;
  fabricVersionSet = toSet sources.fabric.versions;
  quiltVersionSet = toSet sources.quilt.versions;
  forgeVersionSet = toSet sources.forge.versions;
  neoforgeVersionSet = toSet sources.neoforge.versions;
  paperVersionSet = toSet sources.paper.versions;
  foliaVersionSet = toSet sources.folia.versions;
  purpurVersionSet = toSet sources.purpur.versions;
  velocityVersionSet = toSet sources.velocity.versions;
  waterfallVersionSet = toSet sources.waterfall.versions;
in {
  nixcraft.lib.types = rec {
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
        (builtins.isString version && (lwjglVersionSet ? ${version} || sources.lwjgl.components ? ${version}))
        "LWJGL version '${toString version}' does not exist.";
      merge = loc: defs: (lib.head defs).value;
    };

    fabricLoaderVersion = lib.mkOptionType {
      name = "fabricLoaderVersion";
      description = "Fabric loader version";
      check = version:
        lib.assertMsg
        (builtins.isString version && fabricVersionSet ? ${version})
        "Fabric loader version '${toString version}' does not exist.";
      merge = loc: defs: (lib.head defs).value;
    };

    quiltLoaderVersion = lib.mkOptionType {
      name = "quiltLoaderVersion";
      description = "Quilt loader version";
      check = version:
        lib.assertMsg
        (builtins.isString version && quiltVersionSet ? ${version})
        "Quilt loader version '${toString version}' does not exist.";
      merge = loc: defs: (lib.head defs).value;
    };

    forgeLoaderVersion = lib.mkOptionType {
      name = "forgeLoaderVersion";
      description = "Forge loader version";
      check = version:
        lib.assertMsg
        (builtins.isString version && forgeVersionSet ? ${version})
        "Forge loader version '${toString version}' does not exist.";
      merge = loc: defs: (lib.head defs).value;
    };

    neoforgeLoaderVersion = lib.mkOptionType {
      name = "neoforgeLoaderVersion";
      description = "NeoForge loader version";
      check = version:
        lib.assertMsg
        (builtins.isString version && neoforgeVersionSet ? ${version})
        "NeoForge loader version '${toString version}' does not exist.";
      merge = loc: defs: (lib.head defs).value;
    };

    paperVersion = lib.mkOptionType {
      name = "paperVersion";
      description = "Paper server Minecraft version";
      check = version:
        lib.assertMsg
        (builtins.isString version && paperVersionSet ? ${version})
        "Paper server Minecraft version '${toString version}' does not exist.";
      merge = loc: defs: (lib.head defs).value;
    };

    foliaVersion = lib.mkOptionType {
      name = "foliaVersion";
      description = "Folia server Minecraft version";
      check = version:
        lib.assertMsg
        (builtins.isString version && foliaVersionSet ? ${version})
        "Folia server Minecraft version '${toString version}' does not exist.";
      merge = loc: defs: (lib.head defs).value;
    };

    purpurVersion = lib.mkOptionType {
      name = "purpurVersion";
      description = "Purpur server Minecraft version";
      check = version:
        lib.assertMsg
        (builtins.isString version && purpurVersionSet ? ${version})
        "Purpur server Minecraft version '${toString version}' does not exist.";
      merge = loc: defs: (lib.head defs).value;
    };

    velocityVersion = lib.mkOptionType {
      name = "velocityVersion";
      description = "Velocity proxy version";
      check = version:
        lib.assertMsg
        (builtins.isString version && velocityVersionSet ? ${version})
        "Velocity proxy version '${toString version}' does not exist.";
      merge = loc: defs: (lib.head defs).value;
    };

    waterfallVersion = lib.mkOptionType {
      name = "waterfallVersion";
      description = "Waterfall proxy version";
      check = version:
        lib.assertMsg
        (builtins.isString version && waterfallVersionSet ? ${version})
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
