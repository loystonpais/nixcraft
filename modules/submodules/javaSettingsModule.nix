{lib, ...}: {
  name,
  config,
  ...
}: {
  options = {
    package = lib.mkOption {
      type = lib.types.package;
    };

    maxMemory = lib.mkOption {
      type = lib.types.nullOr lib.nixcraft.types.javaMemorySize;
      default = null;
    };

    minMemory = lib.mkOption {
      type = lib.types.nullOr lib.nixcraft.types.javaMemorySize;
      default = null;
    };

    memory = lib.mkOption {
      type = lib.types.nullOr lib.nixcraft.types.javaMemorySize;
      default = null;
    };

    cp = lib.mkOption {
      type = with lib.types; nullOr (listOf path);
      default = null;
    };

    extraArguments = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
    };

    finalArguments = lib.mkOption {
      type = with lib.types; listOf str;
      readOnly = true;
      default = with lib;
        concatLists [
          (optional (config.minMemory != null) "-Xms${toString config.minMemory}m")
          (optional (config.maxMemory != null) "-Xmx${toString config.maxMemory}m")

          (optional (config.cp != null) "-cp")
          (optional (config.cp != null) (concatStringsSep ":" config.cp))

          config.extraArguments
        ];
    };

    finalArgumentShellString = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = with lib;
        escapeShellArgs (
          config.finalArguments
        );
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.memory != null) {
      maxMemory = config.memory;
      minMemory = config.memory;
    })

    {
      _module.check = lib.mkIf (config.minMemory != null && config.maxMemory != null) (
        lib.asserts.assertMsg (config.minMemory <= config.maxMemory)
        "Java min memory can't be more than max memory"
      );
    }
  ];
}
