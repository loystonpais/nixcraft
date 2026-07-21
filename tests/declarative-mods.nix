{
  lib,
  pkgs,
  submodules,
}:
let
  evalClient = cfg:
    lib.evalModules {
      modules = [
        submodules.clientInstanceModule
        cfg
        {
          version = lib.mkDefault "1.21.1";
          account = lib.mkDefault {};
          binEntry.enable = lib.mkDefault false;
          desktopEntry.enable = lib.mkDefault false;
        }
      ];
      specialArgs = {
        shared = {};
        dirPrefix = null;
        name = "declarative-mods-test";
        inherit lib pkgs;
      };
    };

  evalServer = cfg:
    lib.evalModules {
      modules = [
        submodules.serverInstanceModule
        cfg
        {
          version = lib.mkDefault "1.21.1";
          binEntry.enable = lib.mkDefault false;
        }
      ];
      specialArgs = {
        shared = {};
        dirPrefix = null;
        name = "declarative-mods-test";
        inherit lib pkgs;
      };
    };

  clientSource = pkgs.writeText "sodium-source" "client mod";
  replacementSource = pkgs.writeText "lithium-source" "replacement client mod";
  serverSource = pkgs.writeText "fabric-api-source" "server mod";

  clientDir = "/tmp/nixcraft-declarative-mods-client";
  serverDir = "/tmp/nixcraft-declarative-mods-server";

  clientConfig = (evalClient {
    absoluteDir = clientDir;
    mods.sodium = clientSource;
  }).config;

  replacementConfig = (evalClient {
    absoluteDir = clientDir;
    mods.lithium = replacementSource;
  }).config;

  serverConfig = (evalServer {
    absoluteDir = serverDir;
    mods.fabric-api = serverSource;
  }).config;

  failsToEvaluate = evaluated:
    !(builtins.tryEval (builtins.deepSeq evaluated.config.finalFilePlacementShellScript true)).success;

  invalidNameFails = failsToEvaluate (evalClient {
    absoluteDir = clientDir;
    mods."nested/sodium" = clientSource;
  });

  emptyNameFails = failsToEvaluate (evalClient {
    absoluteDir = clientDir;
    mods."" = clientSource;
  });

  jarSuffixFails = failsToEvaluate (evalClient {
    absoluteDir = clientDir;
    mods."sodium.jar" = clientSource;
  });

  newlineNameFails = failsToEvaluate (evalClient {
    absoluteDir = clientDir;
    mods."sodium\nmalicious" = clientSource;
  });

  carriageReturnNameFails = failsToEvaluate (evalClient {
    absoluteDir = clientDir;
    mods."sodium\rmalicious" = clientSource;
  });

  conflictFails = failsToEvaluate (evalClient {
    absoluteDir = clientDir;
    mods.sodium = clientSource;
    files."mods/sodium.jar".source = replacementSource;
  });

  parentConflictFails = failsToEvaluate (evalClient {
    absoluteDir = clientDir;
    mods.sodium = clientSource;
    files.mods.source = replacementSource;
  });

  childConflictFails = failsToEvaluate (evalClient {
    absoluteDir = clientDir;
    mods.sodium = clientSource;
    files."mods/sodium.jar/config".source = replacementSource;
  });
in
pkgs.runCommandLocal "nixcraft-declarative-mods-test" {} ''
  set -eu

  ${assert invalidNameFails; ""}
  ${assert emptyNameFails; ""}
  ${assert jarSuffixFails; ""}
  ${assert newlineNameFails; ""}
  ${assert carriageReturnNameFails; ""}
  ${assert conflictFails; ""}
  ${assert parentConflictFails; ""}
  ${assert childConflictFails; ""}

  ${clientConfig.finalFilePlacementShellScript}
  test -L ${clientDir}/mods/sodium.jar
  test "$(readlink ${clientDir}/mods/sodium.jar)" = ${clientSource}

  ${replacementConfig.finalFilePlacementShellScript}
  test ! -e ${clientDir}/mods/sodium.jar
  test -L ${clientDir}/mods/lithium.jar
  test "$(readlink ${clientDir}/mods/lithium.jar)" = ${replacementSource}

  ${serverConfig.finalFilePlacementShellScript}
  test -L ${serverDir}/mods/fabric-api.jar
  test "$(readlink ${serverDir}/mods/fabric-api.jar)" = ${serverSource}

  touch $out
''
