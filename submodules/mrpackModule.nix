{
  lib,
  parseMrpack,
  ...
}: {
  name,
  config,
  ...
}: {
  options = {
    file = lib.mkOption {
      type = lib.types.package;
    };

    minecraftVersion = lib.mkOption {
      type = lib.types.str;
    };

    fabricLoaderVersion = lib.mkOption {
      type = lib.types.nonEmptyStr;
    };

    enableOptionalMods = (lib.mkEnableOption "optional mods") // {default = true;};

    placeOverrides = (lib.mkEnableOption "placing overrides") // {default = true;};

    _parsedMrpack = lib.mkOption {
      type = lib.types.attrs;
    };
  };

  config = lib.mkMerge [
    {
      _parsedMrpack = parseMrpack config.file;
      minecraftVersion = lib.mkOptionDefault config._parsedMrpack.minecraftVersion;
      fabricLoaderVersion = lib.mkOptionDefault config._parsedMrpack.fabricLoaderVersion;
    }
  ];
}
