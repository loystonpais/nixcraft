{
  nixcraft.lib.clientAuth.mkPackage = pkgs:
    pkgs.writers.writePython3Bin "nixcraft-client-auth" {
      doCheck = false;
    } (builtins.readFile ./client-auth.py);

  nixcraft.docs.examples.auth = {
    offline = {
      offline = true;
      username = "nixcrafter";
    };
    online = {
      offline = false;
      uuid = "your-account-uuid";
    };
    env = {
      uuid = "your-account-uuid";
    };
  };

  nixcraft.docs.readme.sections.auth = {
    order = 50;
    template = ''
      ## Authentication

      Nixcraft supports both offline and Microsoft-authenticated accounts via the `account` option on client instances or globally under `nixcraft.client.shared.account`.

      ### Offline Accounts

      For offline play or local testing, set `offline = true` and specify a username:

      ```nix
      nixcraft.client.shared.account = {{ examples.auth.offline | to_nix }};
      ```

      ### Online Accounts (Microsoft)

      For connecting to online servers and Realms, set `offline = false`. Nixcraft uses a device code authentication flow: on first launch, it displays a code in the terminal that you enter at [microsoft.com/link](https://microsoft.com/link) to sign in, similar to how Prism Launcher handles authentication. Valid session tokens are then pulled dynamically at launch without storing passwords or credentials inside your Nix code:

      ```nix
      nixcraft.client.shared.account = {{ examples.auth.online | to_nix }};
      ```

      When `uuid` is not provided in online mode, it will automatically be picked up from the `NIXCRAFT_CLIENT_AUTH_UUID` environment variable.

      In Home Manager, you can set this variable declaratively:

      ```nix
      nixcraft.client.auth = {{ examples.auth.env | to_nix }};
      ```

      Or export it directly in your shell:

      ```bash
      export NIXCRAFT_CLIENT_AUTH_UUID="your-account-uuid"
      ```
    '';
  };

  perSystem = {
    flakeConfig,
    pkgs,
    ...
  }: {
    packages.client-auth = flakeConfig.nixcraft.lib.clientAuth.mkPackage pkgs;
  };
}
