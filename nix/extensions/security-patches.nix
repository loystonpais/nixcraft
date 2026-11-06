{
  config,
  lib,
  ...
} @ flakeArgs: let
  inherit (config.nixcraft) sources;
in {
  nixcraft.instance.extensions = [
    ({
      config,
      pkgs,
      lib,
      ...
    }: let
      inherit (flakeArgs.config.nixcraft.lib.minecraftVersion) ls lsEq grEq;
      v = config.version;

      # 1.7 <= version < 1.12 (Legacy versions using log4j 2.0-beta9)
      isLegacyLog4j = (grEq v "1.7") && (ls v "1.12");

      # 1.12 <= version < 1.18.2 (Versions using log4j 2.8.1 or 2.14.1)
      isModernLog4j = (grEq v "1.12") && (ls v "1.18.2");

      # Forge versions affected by BleedingPipe (unsafe ObjectInputStream deserialization)
      isBleedingPipeVulnerableForge =
        config.forgeLoader.enable && ((v == "1.7.10") || (v == "1.12.2"));
    in {
      config = lib.mkMerge [
        # Log4Shell (CVE-2021-44228) for Minecraft 1.7 - 1.11.2 (log4j 2.0-beta9)
        (lib.mkIf isLegacyLog4j {
          libraries = {
            # Disable vulnerable 2.0-beta9 libraries
            "org.apache.logging.log4j:log4j-core:2.0-beta9".enable = lib.mkForce false;
            "org.apache.logging.log4j:log4j-api:2.0-beta9".enable = lib.mkForce false;

            # Add patched libraries with JndiLookup.lookup() neutered (MultiMC / Prism Maven)
            "org.apache.logging.log4j:log4j-core:2.0-beta9-fixed" = {
              relativePath = "org/apache/logging/log4j/log4j-core/2.0-beta9-fixed/log4j-core-2.0-beta9-fixed.jar";
              jar = pkgs.fetchurl {
                url = "https://files.multimc.org/maven/org/apache/logging/log4j/log4j-core/2.0-beta9-fixed/log4j-core-2.0-beta9-fixed.jar";
                sha1 = "677991ea2d7426f76309a73739cecf609679492c";
              };
            };
            "org.apache.logging.log4j:log4j-api:2.0-beta9-fixed" = {
              relativePath = "org/apache/logging/log4j/log4j-api/2.0-beta9-fixed/log4j-api-2.0-beta9-fixed.jar";
              jar = pkgs.fetchurl {
                url = "https://files.multimc.org/maven/org/apache/logging/log4j/log4j-api/2.0-beta9-fixed/log4j-api-2.0-beta9-fixed.jar";
                sha1 = "b61eaf2e64d8b0277e188262a8b771bbfa1502b3";
              };
            };
          };
        })

        # Log4Shell (CVE-2021-44228) for Minecraft 1.12 - 1.18.1 (log4j 2.8.1 / 2.14.1)
        (lib.mkIf isModernLog4j {
          libraries = {
            # Disable vulnerable libraries
            "org.apache.logging.log4j:log4j-core:2.8.1".enable = lib.mkForce false;
            "org.apache.logging.log4j:log4j-api:2.8.1".enable = lib.mkForce false;
            "org.apache.logging.log4j:log4j-core:2.14.1".enable = lib.mkForce false;
            "org.apache.logging.log4j:log4j-api:2.14.1".enable = lib.mkForce false;
            "org.apache.logging.log4j:log4j-slf4j18-impl:2.14.1".enable = lib.mkForce false;

            # Add official patched Log4j 2.17.0 libraries using sources.libraries
            "org.apache.logging.log4j:log4j-core:2.17.0" = {
              relativePath = "org/apache/logging/log4j/log4j-core/2.17.0/log4j-core-2.17.0.jar";
              jar = pkgs.fetchurl sources.libraries."org.apache.logging.log4j:log4j-core:2.17.0";
            };
            "org.apache.logging.log4j:log4j-api:2.17.0" = {
              relativePath = "org/apache/logging/log4j/log4j-api/2.17.0/log4j-api-2.17.0.jar";
              jar = pkgs.fetchurl sources.libraries."org.apache.logging.log4j:log4j-api:2.17.0";
            };
            "org.apache.logging.log4j:log4j-slf4j18-impl:2.17.0" = lib.mkIf (config.meta.versionData.libraries ? "org.apache.logging.log4j:log4j-slf4j18-impl:2.14.1") {
              relativePath = "org/apache/logging/log4j/log4j-slf4j18-impl/2.17.0/log4j-slf4j18-impl-2.17.0.jar";
              jar = pkgs.fetchurl sources.libraries."org.apache.logging.log4j:log4j-slf4j18-impl:2.17.0";
            };
          };
        })

        # BleedingPipe: unsafe ObjectInputStream deserialization in Forge 1.7.10 / 1.12.2
        (lib.mkIf isBleedingPipeVulnerableForge (let
          serializationIsBadJar = pkgs.fetchurl {
            url = "https://github.com/dogboy21/serializationisbad/releases/download/1.5.2/serializationisbad-1.5.2.jar";
            hash = "sha256-IDHI7c5LEk8pozybqJK5BJ0Z/P9McR4qonbQUc8NXTE=";
          };
          serializationIsBadConfig = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/dogboy21/serializationisbad/1.5.2/serializationisbad.json";
            hash = "sha256-U3hJgUadOUT7Cibkc5iCkH4zBPCIXtpaVrC6fTZiK4E=";
          };
        in {
          java.extraArguments = ["-javaagent:${serializationIsBadJar}"];
          files."config/serializationisbad.json".source = serializationIsBadConfig;
        }))

        # JNDI hardening (defense-in-depth across all versions)
        {
          java.D = {
            "com.sun.jndi.rmi.object.trustURLCodebase" = "false";
            "com.sun.jndi.cosnaming.object.trustURLCodebase" = "false";
            "com.sun.jndi.ldap.object.trustURLCodebase" = "false";
          };
        }

        # Enforce TLS 1.2+ for HTTPS connections on versions <= 1.16.5
        (lib.mkIf (lsEq v "1.16.5") {
          java.D."https.protocols" = "TLSv1.2,TLSv1.3";
        })
      ];
    })
  ];
}
