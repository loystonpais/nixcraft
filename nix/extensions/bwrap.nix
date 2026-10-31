{
  ...
} @ flakeArgs: {
  nixcraft.instance.extensions = [
    ({
      config,
      pkgs,
      lib,
      ...
    }: {
      options = {
        bwrap = lib.mkOption {
          type = lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "bwrap";
              package = lib.mkOption {
                type = lib.types.package;
                default = flakeArgs.config.nixcraft.lib.bwrap.mkPackage pkgs;
              };
              mountOpenglDriver = lib.mkOption {
                type = lib.types.bool;
                default = true;
              };
              extraArguments = lib.mkOption {
                type = with lib.types; listOf nonEmptyStr;
                default = [];
              };
            };
          };
          default = {};
        };
      };

      config = lib.mkMerge [
        (lib.mkIf config.bwrap.enable (lib.mkMerge [
          {
            launchPrefix.bwrap = {
              enable = true;
              priority = 100;
              command =
                ["${lib.getExe config.bwrap.package}"]
                ++ (lib.optional config.bwrap.mountOpenglDriver "--mount-opengl-driver")
                ++ config.bwrap.extraArguments;
              separator = "--";
            };
          }

          (lib.mkIf (config._instanceType == "client" && config.bwrap.mountOpenglDriver) {
            runtimeLibs = lib.mkAfter (with pkgs; [
              libxau
              libxdmcp
              libxcb
              libxrender
              libxi
              libxinerama
              libdrm
            ]);
          })
        ]))
      ];
    })
  ];
}
