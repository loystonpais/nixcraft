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
        name = "game-options-test";
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
        name = "game-options-test";
        inherit lib pkgs;
      };
    };

  instanceDir = "/tmp/nixcraft-game-options-test";
  configured = (evalClient {
    absoluteDir = instanceDir;
    gameOptions = {
      fov = 0.5;
      fullscreen = true;
      guiScale = 3;
      "key_key.forward" = "key.keyboard.w";
      narrator = null;
    };
  }).config;
  unconfigured = (evalClient {
    absoluteDir = instanceDir;
    gameOptions = {};
  }).config;
  optionsSource = configured._generatedFiles."options.txt".finalSource;
  expectedOptions = pkgs.writeText "expected-options.txt" ''
    fov:0.500000
    fullscreen:true
    guiScale:3
    key_key.forward:key.keyboard.w
  '';

  failsToEvaluate = evaluated:
    !(builtins.tryEval (builtins.deepSeq evaluated.config true)).success;

  emptyKeyFails = failsToEvaluate (evalClient {
    absoluteDir = instanceDir;
    gameOptions."" = true;
  });
  colonKeyFails = failsToEvaluate (evalClient {
    absoluteDir = instanceDir;
    gameOptions."bad:key" = true;
  });
  newlineKeyFails = failsToEvaluate (evalClient {
    absoluteDir = instanceDir;
    gameOptions."bad\nkey" = true;
  });
  multilineValueFails = failsToEvaluate (evalClient {
    absoluteDir = instanceDir;
    gameOptions.language = "en_us\r\ninvalid";
  });
  invalidTypeFails = failsToEvaluate (evalClient {
    absoluteDir = instanceDir;
    gameOptions.invalid = ["not" "scalar"];
  });
  fileConflictFails = failsToEvaluate (evalClient {
    absoluteDir = instanceDir;
    gameOptions.fullscreen = true;
    files."options.txt".text = "fullscreen:false";
  });
  serverOptionFails = failsToEvaluate (evalServer {
    absoluteDir = instanceDir;
    gameOptions.fullscreen = true;
  });
in
pkgs.runCommandLocal "nixcraft-game-options-test" {} ''
  set -eu

  ${assert emptyKeyFails; ""}
  ${assert colonKeyFails; ""}
  ${assert newlineKeyFails; ""}
  ${assert multilineValueFails; ""}
  ${assert invalidTypeFails; ""}
  ${assert fileConflictFails; ""}
  ${assert serverOptionFails; ""}

  ${configured.finalFilePlacementShellScript}
  test -L ${instanceDir}/options.txt
  test "$(readlink ${instanceDir}/options.txt)" = ${optionsSource}
  cmp ${instanceDir}/options.txt ${expectedOptions}

  ${unconfigured.finalFilePlacementShellScript}
  test ! -e ${instanceDir}/options.txt

  touch $out
''
