<div align="center">

# Nixcraft

*A declarative, reproducible Minecraft launcher and server manager in Nix*

[![Flake](https://img.shields.io/badge/Nix-Flakes-5277C3?style=flat-square&logo=nixos&logoColor=white)](https://nixos.org)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS-informational?style=flat-square)](https://github.com/loystonpais/nixcraft)

[Features](#features) • [Quick Start](#quick-start) • [Authentication](#authentication) • [Feature Showcase](#feature-showcase) • [Options Reference](#options-reference)

</div>

---

> [!NOTE]
> **For AI Agents**: Ingest the matching [TOON options tree](docs/agent/options-tree/) for token-efficient context.

Nixcraft is a Minecraft client launcher and a server manager. Instead of managing instances though graphical launchers or manually copying files into mod folders, you take advantage of Nix's powerful module system to declare your instance. One config that sets up clients and servers; reproducible across multiple machines.


## Features

- **Mod loader**: Built-in support for Fabric, Quilt, Forge, and NeoForge, plus Paper, Purpur, and other server software.
- **Modrinth modpacks (.mrpack)**: Point to an `.mrpack` file and Nixcraft downloads the mods, applies overrides, and figures out the right Minecraft and modloader versions automatically.
- **Zero-rebuild installs**: Run or install standalone instances using `nix run` or `nix profile add` without touching your system config or running `nixos-rebuild`.
- **Speedrunning (MCSR) support**: Built-in support for Waywall, world installation, settings injection, java tuning.

> [!WARNING]
> This project is a work in progress. While mostly functional, expect potential breaking changes on updates.


## Quick Start

### Supported Platforms

| Platform | Support |
|---|---|
| x86_64-linux | ✅ First class |
| aarch64-linux | ✅ First class |
| aarch64-darwin (Apple Silicon macOS) | ✅ First class |
| WSL, FreeBSD (Linuxulator) | 🧪 Lightly tested, lower priority |
| Intel macOS (x86_64-darwin) | ❔ May work, untested |

### Where do I start?

- ⚡ **Just want to try it?** No install needed!
  - 🚀 [Run with `nix run`](#try-it-with-nix-run)
  - 📦 [Keep everything in one portable folder (`.pwd`)](#portable-game-directories-pwd)
- 🏠 **Already use Home Manager?** → [Home Manager](#home-manager)
- 🐧 **NixOS user?**
  - 🎮 Clients and servers → [Home Manager](#home-manager) or [nix profile](#nix-profile)
  - 🖥️ Servers → [NixOS module](#nixos-module)
- 🐧 **Any Linus disto like Arch, Fedora, Ubuntu.. or 🍎 MacOS** → [Install Nix](#install-nix), then [nix profile](#nix-profile)

### First time to Nix? Install it.

On non-NixOS Linux disros and MacOS, install Nix with the Determinate installer (flakes are enabled by default):

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

Restart your shell, then check with `nix --version`.

### nix profile

The recommended path for most non-NixOS users. Installs an instance into your user environment without touching system files or writing any config.

> [!IMPORTANT]
> `--impure` is required so Nix can read `$HOME` and `$PWD`. Without it, instance data falls back to `/tmp/nixcraft-...`.

Pass your configuration with `--expr`. `.withConfig` takes the same [options](#options-reference) you would write in Home Manager or the NixOS module, so the config looks the same everywhere:

```bash
# Install a client (adds binary to $PATH; on Linux also a desktop menu shortcut)
nix profile add --impure --expr '
(builtins.getFlake "github:loystonpais/nixcraft").packages.${builtins.currentSystem}.client
  .withConfig {
    name = "survival";
    version = "1.21.1";
  }
'

# Install a Paper server
nix profile add --impure --expr '
(builtins.getFlake "github:loystonpais/nixcraft").packages.${builtins.currentSystem}.server
  .withConfig {
    name = "creative-hub";
    version = "1.21.1";
    agreeToEula = true;
    paper.enable = true;
    serverProperties = {
      "max-players" = 10;
      gamemode = "creative";
    };
  }
'
```

> [!TIP]
> The name decides what the instance is called everywhere: the profile entry is `nixcraft-client-<name>` / `nixcraft-server-<name>`, and the server's systemd user service has the same name. Give each instance a different name to install several side by side. Without `name` it is `default`, so a second install would clash with the first.

> [!IMPORTANT]
> **Non-NixOS Linux, clients only:** enable `bwrap` and `mountOpenglDriver` so the game picks up your system's GPU drivers. Without it, graphics may fall back to software rendering or the wrong GPU. Add this to the client's `.withConfig`:
>
> ```nix
> bwrap = {
>   enable = true;
>   mountOpenglDriver = true;
> };
> ```
>
> Or, for quick runs, use the `withBwrap` combinator: `client.withBwrap`.

**Linux only:** when a server is added via `nix profile`, a systemd user service is automatically included. Manage it with `systemctl --user`:

```bash
# Start or enable the server user service
systemctl --user start nixcraft-server-creative-hub
systemctl --user enable nixcraft-server-creative-hub

# Stop or disable it
systemctl --user stop nixcraft-server-creative-hub
systemctl --user disable nixcraft-server-creative-hub
```

To uninstall an instance:

```bash
nix profile remove nixcraft-server-creative-hub # or nixcraft-client-survival
```

> [!NOTE]
> On macOS there is no service integration yet. To run a server, use [`nix run`](#try-it-with-nix-run).

### Home Manager

Works on any OS for both clients and servers. If you already use Home Manager, start here.

Add Nixcraft to your `flake.nix` inputs:

```nix
# flake.nix
  {
    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      home-manager.url = "github:nix-community/home-manager";
      nixcraft = {
        url = "github:loystonpais/nixcraft";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
  
    outputs = { nixpkgs, home-manager, nixcraft, ... }: {
      # Home Manager configuration
    };
  }
```

Import `inputs.nixcraft.homeModules.default` in your Home Manager configuration:

```nix
# home.nix
{ config, pkgs, inputs, ... }: {
  imports = [
    inputs.nixcraft.homeModules.default
  ];

  nixcraft = {
    client = {
      instances = {
        survival = {
          desktopEntry = {
            enable = true;
          };
          version = "1.21.1";
        };
      };
      shared = {
        account = {
          offline = true;
          username = "nixcrafter";
        };
        enableExternalAssets = true;
      };
    };
    enable = true;
  };
}
```

### NixOS Module

For dedicated **servers only**, run as system-level systemd services.

Import `inputs.nixcraft.nixosModules.default` in your `configuration.nix` to declare system-level servers running under systemd:

```nix
# configuration.nix
{ config, pkgs, inputs, ... }: {
  imports = [
    inputs.nixcraft.nixosModules.default
  ];

  nixcraft = {
    enable = true;
    server = {
      instances = {
        smp = {
          agreeToEula = true;
          java = {
            memory = 4096;
          };
          paper = {
            enable = true;
          };
          service = {
            autoStart = true;
            enable = true;
          };
          version = "1.21.1";
        };
      };
    };
  };
}
```

> [!TIP]
> The instance name (the attribute under `nixcraft.server.instances`, or its `name` option) becomes the systemd service name: `nixcraft-server-<name>`. Different names give different services, e.g. `systemctl status nixcraft-server-creative-hub`.

### Try it with `nix run`

Run an instance immediately without installing anything. Works on Linux and Apple Silicon macOS once [Nix is installed](#install-nix).

> [!IMPORTANT]
> `--impure` is required (see [nix profile](#nix-profile)).

```bash
# Run client on 1.21.1
nix run --impure github:loystonpais/nixcraft#client.v1-21-1

# Run a dedicated Paper server on 1.21.1
nix run --impure github:loystonpais/nixcraft#server.agreeToEula.paper.v1-21-1
```

#### Simple runs with combinators

For simple things, chain combinators with dot-notation right in the flake reference:

```bash
# Paper server + EULA + offline mode + version
nix run --impure github:loystonpais/nixcraft#server.agreeToEula.paper.offlineMode.v1-21-1
```

> [!TIP]
> Don't memorize them. Type `nix run --impure github:loystonpais/nixcraft#client.` and press <kbd>Tab</kbd> to autocomplete the available combinators.

#### Anything more: `--expr`

When combinators aren't enough, use `--expr` with `.withConfig`, the same config you would write in Home Manager or the NixOS module (see [nix profile](#nix-profile)):

```bash
nix run --impure --expr '
(builtins.getFlake "github:loystonpais/nixcraft").packages.${builtins.currentSystem}.server
  .withConfig {
    name = "creative-hub";
    version = "1.21.1";
    agreeToEula = true;
    paper.enable = true;
    serverProperties = {
      "max-players" = 10;
      gamemode = "creative";
    };
  }
'
```

### Portable Game Directories (`.pwd`)

`pwd` is a combinator that sets the instance's game directory to your current working directory (`$PWD`). If a `nixcraft.nix` file exists in that directory, it is automatically picked up and applied as the instance configuration.

This means you can keep your `nixcraft.nix` configuration, world data, mods, and all game files together in a single self-contained folder and move it between machines.

Create a folder with a `nixcraft.nix` inside:

```nix
# ./nixcraft.nix
{
  agreeToEula = true;
  name = "survival-smp";
  paper = {
    enable = true;
  };
  serverProperties = {
    difficulty = "hard";
    motd = "My Portable Nixcraft Server";
  };
  version = "1.21.1";
}
```

Then `cd` into the directory and run:

```bash
# For a server
nix run --impure github:loystonpais/nixcraft#server.pwd

# For a client
nix run --impure github:loystonpais/nixcraft#client.pwd
```

All game files and world data stay inside that directory. `pwd` can be combined with other combinators, but it must always be **last** in the chain:

```bash
nix run --impure github:loystonpais/nixcraft#server.withLazymc.pwd
```


## Authentication

Nixcraft supports both offline and Microsoft-authenticated accounts via the `account` option on client instances or globally under `nixcraft.client.shared.account`.

### Offline Accounts

For offline play or local testing, set `offline = true` and specify a username:

```nix
nixcraft.client.shared.account = {
  offline = true;
  username = "nixcrafter";
};
```

### Online Accounts (Microsoft)

For connecting to online servers and Realms, set `offline = false`. Nixcraft uses a device code authentication flow: on first launch, it displays a code in the terminal that you enter at [microsoft.com/link](https://microsoft.com/link) to sign in, similar to how Prism Launcher handles authentication. Valid session tokens are then pulled dynamically at launch without storing passwords or credentials inside your Nix code:

```nix
nixcraft.client.shared.account = {
  offline = false;
  uuid = "your-account-uuid";
};
```

When `uuid` is not provided in online mode, it will automatically be picked up from the `NIXCRAFT_CLIENT_AUTH_UUID` environment variable.

In Home Manager, you can set this variable declaratively:

```nix
nixcraft.client.auth = {
  uuid = "your-account-uuid";
};
```

Or export it directly in your shell:

```bash
export NIXCRAFT_CLIENT_AUTH_UUID="your-account-uuid"
```


## Feature Showcase


### Modrinth Modpack Support (`.mrpack`)

Point to any `.mrpack` file and Nixcraft handles everything.

```nix
{ pkgs, ... }: {
  nixcraft.client.instances.optimized = {
    desktopEntry = {
      enable = true;
      name = "Simply Optimized";
    };
    mrpack = {
      enable = true;
      file = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/BYfVnHa7/versions/vZZwrcPm/Simply%20Optimized-1.21.1-5.0.mrpack";
          hash = "sha256-n2BxHMmqpOEMsvDqRRYFfamcDCCT4ophUw7QAJQqXmg=";
        };
    };
  };
}
```


### Fabric Mod Loader

Enables Fabric mod loading for client or server instances. Setting `fabricLoader.version = "latest"` automatically resolves the latest compatible loader for your Minecraft version.

```nix
{ ... }: {
  nixcraft.client.instances.fabric = {
    desktopEntry = {
      enable = true;
    };
    fabricLoader = {
      enable = true;
      version = "latest";
    };
    version = "1.21.1";
  };
}
```


### Quilt Mod Loader

Enables Quilt mod loading for client or server instances.

```nix
{ ... }: {
  nixcraft.client.instances.quilt = {
    desktopEntry = {
      enable = true;
    };
    quiltLoader = {
      enable = true;
      version = "latest";
    };
    version = "1.21.1";
  };
}
```


### Forge

Enables Minecraft Forge for client or server instances. The right Forge version for your Minecraft version is picked automatically.

```nix
{ ... }: {
  nixcraft.client.instances.forge = {
    forgeLoader = {
      enable = true;
    };
    java = {
      memory = 6144;
    };
    version = "1.20.1";
  };
}
```


### NeoForge

Enables NeoForge for client or server instances. The right NeoForge version for your Minecraft version is picked automatically.

```nix
{ ... }: {
  nixcraft.client.instances.neoforge = {
    java = {
      memory = 6144;
    };
    neoForgeLoader = {
      enable = true;
    };
    version = "1.21.1";
  };
}
```


### Paper Dedicated Server

Runs a dedicated Paper server:

```nix
nixcraft.server.instances.survival-smp = {
  agreeToEula = true;
  java = {
    memory = 4096;
  };
  paper = {
    enable = true;
  };
  serverProperties = {
    difficulty = "hard";
    max-players = 20;
    motd = "Welcome to Nixcraft SMP";
    online-mode = true;
    server-port = 25565;
  };
  service = {
    autoStart = true;
    enable = true;
  };
  version = "1.21.1";
};
```


### Purpur Server

Runs a Purpur server:

```nix
nixcraft.server.instances.purpur = {
  agreeToEula = true;
  java = {
    memory = 4096;
  };
  purpur = {
    enable = true;
  };
  serverProperties = {
    max-players = 50;
    motd = "Purpur Server";
  };
  version = "1.21.1";
};
```


### Lazymc

Run server with lazymc:

```nix
nixcraft.server.instances.lazymc = {
  agreeToEula = true;
  lazymc = {
    enable = true;
  };
  paper = {
    enable = true;
  };
  service = {
    autoStart = true;
    enable = true;
  };
  version = "1.21.1";
};
```


### Client Options & Worlds (`optionsTxt`, `saves`)

`optionsTxt` merges the given keys into the instance's `options.txt`; anything you don't set stays as the player configured it in-game. `saves` copies world directories into `saves/` **only if they don't exist yet**, so your in-game progress is never overwritten.

```nix
{ ... }: {
  nixcraft.client.instances.survival = {
    optionsTxt = {
      fullscreen = false;
      guiScale = 2;
      lang = "en_us";
      maxFps = 120;
      renderDistance = 16;
    };
    saves = {
      "My World" = ./worlds/my-world;
    };
    version = "1.21.1";
  };
}
```


### Server Properties & World (`serverProperties`, `world`)

`serverProperties` is merged into `server.properties`, and `world` places a world directory the first time (it is never overwritten once it exists).

```nix
{ ... }: {
  nixcraft.server.instances.survival = {
    agreeToEula = true;
    paper = {
      enable = true;
    };
    serverProperties = {
      difficulty = "hard";
      max-players = 10;
      motd = "My Nixcraft Server";
      pvp = false;
    };
    version = "1.21.1";
    world = ./worlds/survival;
  };
}
```


### Mods (`mods`)

Mods are plain jar files, either from the `mods` list (each is linked into `mods/` under its own file name) or placed explicitly through [`files`](#declarative-files-files), which is handy when you want a specific target name or method.

```nix
{ pkgs, ... }: {
  nixcraft.client.instances.modded = {
    fabricLoader = {
      enable = true;
    };
    files = {
      "mods/lithium.jar" = {
        source = pkgs.fetchurl {
            url = "https://example.com/lithium.jar";
            hash = "sha256-...";
          };
      };
    };
    mods = [
        (pkgs.fetchurl {
          url = "https://example.com/sodium.jar";
          hash = "sha256-...";
        })
        ./mods/local-mod.jar
      ];
    version = "1.21.1";
  };
}
```

Both work for clients and servers.


### Declarative Files (`files`)

Manages any file inside an instance directory. Each entry takes either `.source` (a path or derivation) or `.text`, and a placement `method`:

```nix
{ ... }: {
  nixcraft.client.instances.customized = {
    files = {
      "config/hud.json" = {
        type = "json";
        value = {
          scale = 1.5;
          showFps = true;
        };
      };
      "config/starter-kit.json" = {
        method = "copy-init";
        text = ''
          { "kit": "basic" }'';
      };
      "config/welcome.txt" = {
        text = "Welcome to my instance!";
      };
      "notes/changelog.md" = {
        method = "copy";
        text = "# Changelog";
      };
      "resourcepacks/faithful.zip" = {
        method = "symlink";
        source = ./faithful.zip;
      };
    };
    version = "1.21.1";
  };
}
```

- `symlink` (default): An immutable symlink into the Nix store, refreshed on every activation. Ideal for read-only static files.
- `copy`: Re-copies the file fresh on every rebuild.
- `copy-init`: Copies the file once on initial setup and never overwrites later in-game edits. Ideal for starter configs and modpack defaults.
- `merge`: Deep-merges structured data into an existing file at runtime (see below).

Instead of `.text` or `.source`, you can set `.type` and provide `.value` as plain Nix data, and Nixcraft serializes it for you (like `config/hud.json` above). This works with every method, not just `merge`. Supported types: `json`, `toml`, `ini`, `properties`, `options-txt`, and `txt-list`.

#### Merging structured files

`merge` supports JSON, TOML, YAML, INI, `.properties`, and `options.txt`. Set `type` and give a `value`; keys you specify are written, everything else in the existing file (including values the game or the user changed) is left alone:

```nix
{ ... }: {
  nixcraft.client.instances.customized = {
    files = {
      "config/example-mod.json" = {
        method = "merge";
        type = "json";
        value = {
          enableFeature = true;
          maxThreads = 4;
          tuning = {
            cacheSize = 256;
          };
        };
      };
    };
    version = "1.21.1";
  };
}
```

> [!NOTE]
> When providing static content via `.source` or `.text`, omit `.type` unless you need format conversion or validation. Specifying `.type` triggers evaluation-time deserialization and Import-From-Derivation (IFD).


### Minecraft Speedrunning (MCSR) & Waywall

For MCSR speedrunning with Waywall overlays, practice map loading, official leaderboard-approved GLFW binaries (`mcsr.enable = true`).

```nix
{ pkgs, ... }: {
  nixcraft.client.instances.rsg = {
    binEntry = {
      enable = true;
      name = "rsg";
    };
    java = {
      extraArguments = [
        "-XX:+UseZGC"
        "-XX:+AlwaysPreTouch"
        "-Dgraal.TuneInlinerExploration=1"
        "-XX:NmethodSweepActivity=1"
      ];
      maxMemory = 3500;
      minMemory = 3500;
      package = pkgs.jdk17;
    };
    mcsr = {
      enable = true;
    };
    mrpack = {
      enable = true;
      file = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/1uJaMUOm/versions/jIrVgBRv/SpeedrunPack-mc1.16.1-v5.3.0.mrpack";
          hash = "sha256-uH/fGFrqP2UpyCupyGjzFB87LRldkPkcab3MzjucyPQ=";
        };
    };
    saves = {
      "Practice Map" = pkgs.fetchzip {
          url = "https://github.com/Dibedy/The-MCSR-Practice-Map/releases/download/1.0.1/MCSR.Practice.v1.0.1.zip";
          stripRoot = false;
          hash = "sha256-ukedZCk6T+KyWqEtFNP1soAQSFSSzsbJKB3mU3kTbqA=";
        };
    };
    version = "1.16.1";
    waywall = {
      enable = true;
    };
  };
}
```


### Shared Client Configuration

Define shared options inherited by all client instances, including offline/online accounts, common desktop shortcuts, persistent file links, and discrete GPU offloading (`useDiscreteGPU = true`).

```nix
{ config, ... }: {
  nixcraft.client.shared = {
    account = {
      offline = true;
      username = "nixcrafter";
    };
    binEntry = {
      enable = true;
    };
    files = {
      screenshots = {
        source = "${config.home.homeDirectory}/Pictures/Minecraft";
      };
    };
    useDiscreteGPU = true;
  };
}
```


## Options Reference

Nixcraft offers context-specific options for system and user modules as well as standalone client and server packages. Choose the reference matching how you use Nixcraft:

- **[NixOS options](docs/human/options-tree/nixos.md)**
- **[Home Manager options](docs/human/options-tree/home-manager.md)**
- **[Standalone client options](docs/human/options-tree/client.md)**
- **[Standalone server options](docs/human/options-tree/server.md)**

Token-efficient [agent references](docs/agent/options-tree/) are available for the same four contexts.
