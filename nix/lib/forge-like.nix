{lib, ...}: {
  nixcraft.lib.forgeLike = rec {
    # Keep only the loader specific arguments of a launcher `minecraftArguments` string,
    # i.e. drop every `--flag ${placeholder}` pair that the instance fills in itself.
    parseLoaderArguments = str: let
      isFlag = lib.hasPrefix "--";
      isPlaceholder = lib.hasInfix "\${";
      go = acc: tokens:
        if tokens == []
        then acc
        else let
          head = builtins.head tokens;
          rest = builtins.tail tokens;
        in
          if isFlag head && rest != [] && !(isFlag (builtins.head rest))
          then
            go
            (acc ++ lib.optionals (!isPlaceholder (builtins.head rest)) [head (builtins.head rest)])
            (builtins.tail rest)
          else go (acc ++ lib.optional (!isPlaceholder head) head) rest;
    in
      go [] (lib.filter (s: s != "") (lib.splitString " " str));

    # Patch an installer jar to run hermetically offline:
    # 1. Strips DOWNLOAD_MOJMAPS processor task from install_profile.json
    # 2. Strips META-INF code signatures (*.SF, *.RSA, *.DSA) so the modified jar is treated as unsigned
    patchInstallerJar = {
      pkgs,
      installerJar,
      version,
    }:
      pkgs.runCommand "installer-${version}.jar" {
        nativeBuildInputs = [pkgs.unzip pkgs.zip pkgs.jq];
      } ''
        cp ${installerJar} $out
        chmod u+w $out
        if unzip -p "$out" install_profile.json > /dev/null 2>&1; then
          unzip -p "$out" install_profile.json | jq '
            if .processors then
              .processors |= map(select(.args and (.args | index("DOWNLOAD_MOJMAPS")) | not))
            else
              .
            end
          ' > install_profile.json
          zip -q -u "$out" install_profile.json
          rm install_profile.json
          zip -q -d "$out" "META-INF/*.SF" "META-INF/*.RSA" "META-INF/*.DSA" 2>/dev/null || true
        fi
      '';

    # Convert Mojang Proguard mappings (.txt) to TSRG format using Forge's bundled srgutils library
    convertToTsrg = {
      pkgs,
      javaPackage,
      srgutilsJar,
      name,
      txtFile,
    }:
      pkgs.runCommand "${name}-mappings.tsrg" {} ''
        cat << 'EOF' > Convert.java
        import java.io.File;
        import net.minecraftforge.srgutils.IMappingFile;

        public class Convert {
            public static void main(String[] args) throws Exception {
                var map = IMappingFile.load(new File(args[0]));
                map.write(new File(args[1]).toPath(), IMappingFile.Format.TSRG, false);
            }
        }
        EOF
        ${javaPackage}/bin/java -cp "${srgutilsJar}" Convert.java "${txtFile}" "$out"
      '';
  };
}
