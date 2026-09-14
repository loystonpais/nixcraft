{
  pkgs,
  lib,
  submodules,
  sources,
  cfg ? {},
  name ? "default",
  ...
}: let
  serverInstanceModule = submodules.serverInstanceModule;

  isImpure = builtins ? currentSystem;
  homeDir =
    if isImpure
    then builtins.getEnv "HOME"
    else "";
  hasHome = isImpure && homeDir != "";

  evalPackage = {cfgModules, ...}: let
    evaluated = lib.evalModules {
      modules =
        [
          serverInstanceModule
          {
            version = lib.mkDefault "latest-release";
            absoluteDir = lib.mkDefault (
              if hasHome
              then "${homeDir}/.local/share/nixcraft/server/instances/${name}"
              else "/tmp/nixcraft-server/${name}"
            );
            binEntry.enable = lib.mkDefault true;
          }
        ]
        ++ cfgModules;
      specialArgs = {
        shared = {};
        dirPrefix = null;
        inherit name pkgs lib;
      };
    };

    service = rec {
      serviceName = evaluated.config.binEntry.name;

      serviceText = ''
        [Unit]
        Description=Minecraft Server ${name}
        After=network.target
        Wants=network.target

        [Service]
        Type=simple
        ExecStart=${lib.getExe evaluated.config.binEntry.finalBin}
        Restart=on-failure

        [Install]
        WantedBy=default.target
      '';

      shareItem = pkgs.writeTextDir "share/systemd/user/${serviceName}.service" serviceText;
      libItem = pkgs.writeTextDir "lib/systemd/user/${serviceName}.service" serviceText;
    };

    finalEntry = pkgs.symlinkJoin {
      name = "nixcraft-server-${name}";
      paths = [
        service.shareItem
        service.libItem
        evaluated.config.binEntry.finalBin
      ];

      meta.mainProgram = evaluated.config.binEntry.name;

      passthru = {
        evaluatedModule = evaluated;
      };
    };
  in
    finalEntry;

  extraCombinators = withConfig: rec {
    agreeToEula = withConfig {
      agreeToEula = true;
    };

    withPaper = withConfig {
      paper.enable = true;
    };
    paper = withPaper;

    withLazymc = withConfig {
      lazymc.enable = true;
    };
    lazymc = withLazymc;

    withNoGui = withConfig {
      noGui = true;
    };

    withGui = withConfig {
      noGui = false;
    };

    withServerProperties = props:
      withConfig {
        serverProperties = props;
      };

    offlineMode = withServerProperties {
      online-mode = false;
    };

    withWorld = world:
      withConfig {
        inherit world;
      };
  };
in
  (lib.nixcraft.makeInstancePackage {
    inherit sources evalPackage extraCombinators;
  })
  cfg
