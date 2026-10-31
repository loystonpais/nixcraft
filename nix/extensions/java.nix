{
  config,
  lib,
  ...
} @ flakeArgs: {
  nixcraft.instance.extensions = [
    ({
      name,
      config,
      pkgs,
      lib,
      ...
    }: {
      options = {
          java = lib.mkOption {
            type = lib.types.submodule (submoduleArgs: let
              javaConfig = submoduleArgs.config;
            in {
              options = {
                package = lib.mkOption {
                  type = lib.types.package;
                  description = "Java runtime package to use.";
                };

                maxMemory = lib.mkOption {
                  type = lib.types.nullOr flakeArgs.config.nixcraft.lib.types.javaMemorySize;
                  default = null;
                  description = "Maximum memory limit (in MB) for the JVM (-Xmx).";
                };

                minMemory = lib.mkOption {
                  type = lib.types.nullOr flakeArgs.config.nixcraft.lib.types.javaMemorySize;
                  default = null;
                  description = "Initial memory allocation (in MB) for the JVM (-Xms).";
                };

                memory = lib.mkOption {
                  type = lib.types.nullOr flakeArgs.config.nixcraft.lib.types.javaMemorySize;
                  default = null;
                  description = "Sets both minMemory and maxMemory to the same value.";
                };

                cp = lib.mkOption {
                  type = with lib.types; (listOf path);
                  default = [];
                  description = "Java classpath (-cp) entries.";
                };

                jar = lib.mkOption {
                  type = lib.types.nullOr lib.types.path;
                  default = null;
                  description = "Main jar file to run with -jar.";
                };

                mainClass = lib.mkOption {
                  type = lib.types.nullOr lib.types.nonEmptyStr;
                  default = null;
                  description = "Main class to execute.";
                };

                D = lib.mkOption {
                  type = with lib.types; attrsOf (oneOf [str path package int bool float]);
                  default = {};
                  description = "Java system properties (-D flags) to pass to the JVM.";
                };

                extraArguments = lib.mkOption {
                  type = with lib.types; listOf nonEmptyStr;
                  default = [];
                  description = "Extra JVM arguments.";
                };

                finalArguments = lib.mkOption {
                  type = with lib.types; listOf str;
                  readOnly = true;
                  description = "Complete list of JVM arguments constructed from all Java options.";
                  default = with lib;
                    concatLists [
                      (optional (javaConfig.minMemory != null) "-Xms${toString javaConfig.minMemory}m")
                      (optional (javaConfig.maxMemory != null) "-Xmx${toString javaConfig.maxMemory}m")

                      (mapAttrsToList (k: v: "-D${k}=${toString v}") javaConfig.D)

                      (optional (javaConfig.cp != []) "-cp")
                      (optional (javaConfig.cp != []) (concatStringsSep ":" javaConfig.cp))

                      javaConfig.extraArguments

                      (optional (javaConfig.jar != null) "-jar")
                      (optional (javaConfig.jar != null) "${javaConfig.jar}")

                      (optional (javaConfig.mainClass != null) javaConfig.mainClass)
                    ];
                };

                finalArgumentShellString = lib.mkOption {
                  type = lib.types.str;
                  readOnly = true;
                  description = "Shell-escaped string of finalArguments.";
                  default = with lib;
                    escapeShellArgs javaConfig.finalArguments;
                };
              };

              config = lib.mkMerge [
                {
                  package = lib.mkOptionDefault (let
                    inherit (flakeArgs.config.nixcraft.lib.minecraftVersion) lsEq;
                    versionLsOrEqTo = lsEq config.version;

                    versionFromManifest = config.meta.versionData.javaVersion.majorVersion or null;

                    versionGuessed =
                      if versionLsOrEqTo "1.16.5"
                      then 8
                      else if versionLsOrEqTo "1.17.1"
                      then 16
                      else if versionLsOrEqTo "1.20.6"
                      then 17
                      else 21;

                    finalVersion =
                      if versionFromManifest != null
                      then versionFromManifest
                      else versionGuessed;
                  in
                    pkgs."jdk${toString finalVersion}" or pkgs.jdk);
                }

                (lib.mkIf (javaConfig.memory != null) {
                  maxMemory = javaConfig.memory;
                  minMemory = javaConfig.memory;
                })

                {
                  _module.check = lib.mkIf (javaConfig.minMemory != null && javaConfig.maxMemory != null) (
                    lib.asserts.assertMsg (javaConfig.minMemory <= javaConfig.maxMemory)
                    "Java min memory can't be more than max memory"
                  );
                }

                {
                  _module.check =
                    lib.assertMsg ((javaConfig.mainClass != null -> javaConfig.jar == null) && (javaConfig.jar != null -> javaConfig.mainClass == null))
                    "Either .jar or .mainClass needs to be provided not both";
                }
              ];
            });
            description = "Java runtime and execution settings.";
            default = {};
          };
        };
      })
  ];
}
