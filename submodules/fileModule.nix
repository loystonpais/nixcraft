{
  lib,
  pkgs,
  ...
}: {
  name,
  config,
  ...
}: let
  allSupportedTypes = [
    "json"
    "toml"
    "yaml"
    "ini"
    "txt-list"
    "properties"
    "options-txt"
  ];

  writableTypes = [
    "json"
    "toml"
    "yaml"
    "ini"
    "txt-list"
    "properties"
    "options-txt"
  ];

  readableTypes = [
    "json"
    "toml"
    "txt-list"
  ];
in {
  options = {
    enable = (lib.mkEnableOption name) // {default = true;};

    target = lib.mkOption {
      type = lib.types.pathWith {absolute = false;};
      default = name;
    };

    dirName = lib.mkOption {
      readOnly = true;
      default = builtins.dirOf config.target;
    };

    fileName = lib.mkOption {
      readOnly = true;
      default = builtins.baseNameOf config.target;
    };

    method = lib.mkOption {
      type = lib.types.enum ["copy" "copy-init" "symlink"];
      default = "symlink";
      description = ''
        Method to place the file in target location
          copy-init     - copy once during init (suitable for config files from modpacks)
          copy          - copy every rebuild
          symlink - symlink every rebuild
      '';
    };

    force = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Overwrite previously existing file/symlink/dir
      '';
    };

    type = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum allSupportedTypes);
      default = null;
      description = ''
        Type of the file. This is used while converting passed value to the
        desired file format. This is totally optional and need NOT be set when .source / .text is defined
        as it can cause unncesessary IFD (Import From Derivation)
      '';
    };

    source = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
    };

    value = lib.mkOption {
      type = with lib.types; oneOf [(listOf anything) (attrsOf anything) anything];
      description = ''
        A value that will be transformed to the desired format when .type is set
      '';
    };

    text = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };

    finalSource = lib.mkOption {
      type = lib.types.path;
      readOnly = true;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.type != null && (config.source != null || config.text != null)) (let
      text =
        if config.source != null
        then builtins.readFile config.source
        else if config.text != null
        then config.text
        else null;
    in
      lib.mkMerge [
        (lib.mkIf (config.type == "json") {
          value = builtins.fromJSON text;
        })

        (lib.mkIf (config.type == "toml") {
          value = builtins.fromTOML text;
        })

        (lib.mkIf (config.type == "txt-list") {
          value = lib.splitString "\n" text;
        })
      ]))

    {
      finalSource =
        if config.type != null
        then
          (
            if config.type == "json"
            then builtins.toFile "value" (builtins.toJSON config.value)
            else if config.type == "txt-list"
            then (lib.concatStringsSep "\n" config.value)
            else if config.type == "toml"
            then (pkgs.formats.toml {}).generate "value" config.value
            else if config.type == "properties"
            then (pkgs.formats.keyValue {}).generate "value" config.value
            else if config.type == "ini"
            then (pkgs.formats.ini {}).generate "value" config.value
            else if config.type == "options-txt"
            then lib.nixcraft.toMinecraftOptionsTxt config.value
            else throw "file ${config.target}: cannot transform value to type ${config.type}"
          )
        else if config.source != null
        then config.source
        else if config.text != null
        then pkgs.writeText "text" config.text
        else throw "file ${config.target}: cannot form finalSource";
    }

    # TODO: find correct way to do validations
    {
      _module.check = lib.all (a: a) [
        (
          lib.assertMsg
          ((lib.count (v: v != null) [
              config.source
              config.text
            ])
            <= 1) "file ${config.target}: cannot have both .source and .text defined"
        )

        (
          lib.assertMsg ((config.type
            != null
            && ((builtins.elem config.type readableTypes) == false))
          -> (config.source == null && config.text == null))
          "file ${config.target}: .source / .text cannot be transformed to value when type is ${config.type}"
        )
      ];
    }
  ];
}
