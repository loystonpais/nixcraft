{
  config,
  lib,
  ...
}: let
  inherit (config.nixcraft) sources;
in {
  nixcraft.lib.options = {
    # source https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/config/shells-environment.nix#L39
    envVars = lib.mkOption {
      example = {
        FOO = "BAR";
      };
      type = with lib.types;
        attrsOf (
          nullOr (oneOf [
            (listOf (oneOf [
              int
              str
              path
            ]))
            int
            str
            path
          ])
        );
      apply = let
        toStr = v:
          if lib.isPath v
          then "${v}"
          else toString v;
      in
        attrs:
          lib.mapAttrs (n: v:
            if lib.isList v
            then lib.concatMapStringsSep ":" toStr v
            else toStr v) (
            lib.filterAttrs (n: v: v != null) attrs
          );
    };

    minecraftVersionDyn = lib.mkOption {
      type = with lib.types;
        either (enum ["latest-release" "latest-snapshot"])
        config.nixcraft.lib.types.minecraftVersion;
      description = "Minecraft version, or one of: latest-release, latest-snapshot";

      apply = version:
        if version == "latest-release"
        then sources.mojang.meta.latest.release
        else if version == "latest-snapshot"
        then sources.mojang.meta.latest.snapshot
        else version;
    };

    fabricLoaderVersionDyn = lib.mkOption {
      type = with lib.types;
        either (enum ["latest"])
        config.nixcraft.lib.types.fabricLoaderVersion;
      description = "Fabric loader version, or 'latest'";

      apply = version:
        if version == "latest"
        then builtins.head sources.fabric.versions
        else version;
    };

    quiltLoaderVersionDyn = lib.mkOption {
      type = with lib.types;
        either (enum ["latest"])
        config.nixcraft.lib.types.quiltLoaderVersion;
      description = "Quilt loader version, or 'latest'";

      apply = version:
        if version == "latest"
        then builtins.head sources.quilt.versions
        else version;
    };

    forgeLoaderVersionDyn = lib.mkOption {
      type = with lib.types;
        either (enum ["latest"])
        config.nixcraft.lib.types.forgeLoaderVersion;
      description = "Forge loader version, or 'latest'";

      apply = version:
        if version == "latest"
        then builtins.head sources.forge.versions
        else version;
    };

    neoforgeLoaderVersionDyn = lib.mkOption {
      type = with lib.types;
        either (enum ["latest"])
        config.nixcraft.lib.types.neoforgeLoaderVersion;
      description = "NeoForge loader version, or 'latest'";

      apply = version:
        if version == "latest"
        then builtins.head sources.neoforge.versions
        else version;
    };

    lwjglVersionDyn = lib.mkOption {
      type = with lib.types;
        either (enum ["latest"])
        config.nixcraft.lib.types.lwjglVersion;
      description = "LWJGL version, or 'latest'";

      apply = version:
        if version == "latest"
        then builtins.head sources.lwjgl.versions
        else version;
    };

    paperVersionDyn = lib.mkOption {
      type = with lib.types;
        either (enum ["latest"])
        config.nixcraft.lib.types.paperVersion;
      description = "Paper server Minecraft version, or 'latest'";

      apply = version:
        if version == "latest"
        then builtins.head sources.paper.versions
        else version;
    };

    foliaVersionDyn = lib.mkOption {
      type = with lib.types;
        either (enum ["latest"])
        config.nixcraft.lib.types.foliaVersion;
      description = "Folia server Minecraft version, or 'latest'";

      apply = version:
        if version == "latest"
        then builtins.head sources.folia.versions
        else version;
    };

    purpurVersionDyn = lib.mkOption {
      type = with lib.types;
        either (enum ["latest"])
        config.nixcraft.lib.types.purpurVersion;
      description = "Purpur server Minecraft version, or 'latest'";

      apply = version:
        if version == "latest"
        then builtins.head sources.purpur.versions
        else version;
    };

    velocityVersionDyn = lib.mkOption {
      type = with lib.types;
        either (enum ["latest"])
        config.nixcraft.lib.types.velocityVersion;
      description = "Velocity proxy version, or 'latest'";

      apply = version:
        if version == "latest"
        then builtins.head sources.velocity.versions
        else version;
    };

    waterfallVersionDyn = lib.mkOption {
      type = with lib.types;
        either (enum ["latest"])
        config.nixcraft.lib.types.waterfallVersion;
      description = "Waterfall proxy version, or 'latest'";

      apply = version:
        if version == "latest"
        then builtins.head sources.waterfall.versions
        else version;
    };
  };
}
