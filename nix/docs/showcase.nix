{...}: {
  nixcraft.docs.examples.client.optionsSaves = {
    version = "1.21.1";
    optionsTxt = {
      renderDistance = 16;
      maxFps = 120;
      guiScale = 2;
      lang = "en_us";
      fullscreen = false;
    };
    saves = {
      "My World" = {
        _type = "raw";
        text = "./worlds/my-world";
      };
    };
  };

  nixcraft.docs.examples.server.propertiesWorld = {
    version = "1.21.1";
    agreeToEula = true;
    paper.enable = true;
    serverProperties = {
      motd = "My Nixcraft Server";
      "max-players" = 10;
      difficulty = "hard";
      pvp = false;
    };
    world = {
      _type = "raw";
      text = "./worlds/survival";
    };
  };

  nixcraft.docs.examples.client.mods = {
    version = "1.21.1";
    fabricLoader.enable = true;

    # Option 1: the `mods` list
    mods = {
      _type = "raw";
      text = ''
        [
          (pkgs.fetchurl {
            url = "https://example.com/sodium.jar";
            hash = "sha256-...";
          })
          ./mods/local-mod.jar
        ]'';
    };

    # Option 2: place jars yourself through `files`
    files."mods/lithium.jar" = {
      source = {
        _type = "raw";
        text = ''
          pkgs.fetchurl {
            url = "https://example.com/lithium.jar";
            hash = "sha256-...";
          }'';
      };
    };
  };

  nixcraft.docs.readme.sections.optionsSaves = {
    order = 66.1;
    template = ''
      ### Client Options & Worlds (`optionsTxt`, `saves`)

      `optionsTxt` merges the given keys into the instance's `options.txt`; anything you don't set stays as the player configured it in-game. `saves` copies world directories into `saves/` **only if they don't exist yet**, so your in-game progress is never overwritten.

      ```nix
      { ... }: {
        nixcraft.client.instances.survival = {{ examples.client.optionsSaves | to_nix | indent(2) }};
      }
      ```
    '';
  };

  nixcraft.docs.readme.sections.propertiesWorld = {
    order = 66.2;
    template = ''
      ### Server Properties & World (`serverProperties`, `world`)

      `serverProperties` is merged into `server.properties`, and `world` places a world directory the first time (it is never overwritten once it exists).

      ```nix
      { ... }: {
        nixcraft.server.instances.survival = {{ examples.server.propertiesWorld | to_nix | indent(2) }};
      }
      ```
    '';
  };

  nixcraft.docs.readme.sections.mods = {
    order = 66.3;
    template = ''
      ### Mods (`mods`)

      Mods are plain jar files, either from the `mods` list (each is linked into `mods/` under its own file name) or placed explicitly through [`files`](#declarative-files-files), which is handy when you want a specific target name or method.

      ```nix
      { pkgs, ... }: {
        nixcraft.client.instances.modded = {{ examples.client.mods | to_nix | indent(2) }};
      }
      ```

      Both work for clients and servers.
    '';
  };
}
