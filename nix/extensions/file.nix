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
    }: let
      defaultFileMergePackage = flakeArgs.config.nixcraft.lib.fileMerge.mkPackage pkgs;
      inherit (lib) escapeShellArg filterAttrs;

      allSupportedTypes = [
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
        "options-txt"
      ];

      fileSubmodule = {
        name,
        config,
        ...
      }: {
        options = {
          enable = (lib.mkEnableOption name) // {default = true;};

          target = lib.mkOption {
            type = lib.types.pathWith {absolute = false;};
            readOnly = true;
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

          method = lib.mkOption {
            type = lib.types.enum ["copy" "copy-init" "symlink" "world" "merge"];
            default = "symlink";
            description = ''
              Method to place the file in target location
                copy-init     - copy once during init (suitable for config files from modpacks)
                copy          - copy every rebuild
                symlink       - symlink every rebuild
                merge         - merge file at runtime
                world         - recursive copy directory only if it doesn't exist already (used internally for world/saves)
            '';
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

              (lib.mkIf (config.type == "options-txt") {
                value = flakeArgs.config.nixcraft.lib.fromMinecraftOptionsTxt text;
              })
            ]))

          {
            finalSource =
              if config.type != null
              then
                (
                  if config.type == "json"
                  then pkgs.writeText "value" (builtins.toJSON config.value)
                  else if config.type == "txt-list"
                  then pkgs.writeText "value" (lib.concatStringsSep "\n" config.value)
                  else if config.type == "toml"
                  then (pkgs.formats.toml {}).generate "value" config.value
                  else if config.type == "properties"
                  then (pkgs.formats.keyValue {}).generate "value" config.value
                  else if config.type == "ini"
                  then (pkgs.formats.ini {}).generate "value" config.value
                  else if config.type == "options-txt"
                  then pkgs.writeText "value" (flakeArgs.config.nixcraft.lib.toMinecraftOptionsTxt config.value)
                  else throw "file ${config.target}: cannot transform value to type ${config.type}"
                )
              else if config.source != null
              then config.source
              else if config.text != null
              then pkgs.writeText "text" config.text
              else throw "file ${config.target}: cannot form finalSource";
          }

          # Validations
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

              (lib.assertMsg (lib.path.subpath.isValid config.target) "file path '${config.target}' is not valid")

              (
                lib.assertMsg (
                  (lib.path.subpath.isValid config.target)
                  && ((lib.removePrefix "./" (lib.path.subpath.normalise config.target)) == config.target)
                ) "file path '${config.target}' is not normal"
              )
            ];
          }
        ];
      };
    in {
      options = {
        files = lib.mkOption {
          type = with lib.types; attrsOf (submodule fileSubmodule);
          default = {};
        };

        placeFilesAtActivation =
          (lib.mkEnableOption "placing files during activation")
          // {
            default = false;
          };

        finalFilePlacementShellScript = lib.mkOption {
          type = lib.types.lines;
          readOnly = true;
        };
      };

      config = lib.mkMerge [
        (lib.mkIf (config.placeFilesAtActivation) {
          activationShellScript = ''
            mkdir -p ${escapeShellArg config.absoluteDir}

            ${config.finalFilePlacementShellScript}
          '';
        })

        (lib.mkIf (!config.placeFilesAtActivation) {
          preLaunchShellScript = ''
            mkdir -p ${escapeShellArg config.absoluteDir}

            ${config.finalFilePlacementShellScript}
          '';
        })

        # file placement logic
        {
          # guard some paths
          files = {
            ".nixcraft".enable = lib.mkForce false;
            ".nixcraft/files".enable = lib.mkForce false;
            ".nixcraft/init".enable = lib.mkForce false;
          };

          finalFilePlacementShellScript = let
            fileMerge = defaultFileMergePackage;
            esc = lib.escapeShellArg;
            entryFilePath = "${config.absoluteDir}/.nixcraft/files";
            initFilePath = "${config.absoluteDir}/.nixcraft/init";

            newEntriesFile = pkgs.writeText "entries" (
              lib.concatMapAttrsStringSep "\n" (name: file: "${config.absoluteDir}/${file.target}") files'entries
            );

            enabledFiles = filterAttrs (name: file: file.enable) config.files;

            files'copy = filterAttrs (name: file: file.method == "copy") enabledFiles;
            files'symlink = filterAttrs (name: file: file.method == "symlink") enabledFiles;
            files'copy-init = filterAttrs (name: file: file.method == "copy-init") enabledFiles;
            files'world = filterAttrs (name: file: file.method == "world") enabledFiles;
            files'merge = filterAttrs (name: file: file.method == "merge") enabledFiles;

            files'entries = filterAttrs (name: file: file.method == "copy" || file.method == "symlink") enabledFiles;

            script'copy-init =
              lib.concatMapAttrsStringSep "\n" (name: file: let
                fileAbsPath = "${config.absoluteDir}/${file.target}";
                fileAbsDirPath = dirOf fileAbsPath;
              in ''
                mkdir -p ${esc fileAbsDirPath}
                rm -rf ${esc fileAbsPath}
                cp ${esc file.finalSource} ${esc fileAbsPath}
                chmod u+w ${esc fileAbsPath}
              '')
              files'copy-init;

            script'copy =
              lib.concatMapAttrsStringSep "\n" (name: file: let
                fileAbsPath = "${config.absoluteDir}/${file.target}";
                fileAbsDirPath = dirOf fileAbsPath;
              in ''
                mkdir -p ${esc fileAbsDirPath}
                rm -rf ${esc fileAbsPath}
                cp ${esc file.finalSource} ${esc fileAbsPath}
                chmod u+w ${esc fileAbsPath}
              '')
              files'copy;

            script'symlink =
              lib.concatMapAttrsStringSep "\n" (name: file: let
                fileAbsPath = "${config.absoluteDir}/${file.target}";
                fileAbsDirPath = dirOf fileAbsPath;
              in ''
                mkdir -p ${esc fileAbsDirPath}
                rm -rf ${esc fileAbsPath}
                ln -s ${esc file.finalSource} ${esc fileAbsPath}
              '')
              files'symlink;

            script'merge =
              lib.concatMapAttrsStringSep "\n" (name: file: let
                fileAbsPath = "${config.absoluteDir}/${file.target}";
                fileAbsDirPath = dirOf fileAbsPath;
                patchJson = pkgs.writeText "${file.fileName}.patch.json" (builtins.toJSON file.value);
              in ''
                mkdir -p ${esc fileAbsDirPath}
                ${lib.getExe fileMerge} ${esc file.type} ${esc patchJson} ${esc fileAbsPath} ${esc fileAbsPath}
              '')
              files'merge;

            script'world =
              lib.concatMapAttrsStringSep "\n" (name: file: let
                fileAbsPath = "${config.absoluteDir}/${file.target}";
                fileAbsDirPath = dirOf fileAbsPath;
                tmpPath = "${config.absoluteDir}/.nixcraft/world-tmp-${file.fileName}-${builtins.hashString "sha1" file.target}";
              in ''
                if [ ! -d ${esc fileAbsPath} ]; then
                  mkdir -p ${esc fileAbsDirPath}
                  rm -rf ${esc tmpPath}
                  cp -rT ${esc file.finalSource} ${esc tmpPath}
                  chmod -R u+w ${esc tmpPath}
                  mv ${esc tmpPath} ${esc fileAbsPath}
                fi
              '')
              files'world;
          in ''
            mkdir -p ${esc config.absoluteDir}
            exec 200< ${esc config.absoluteDir}
            ${pkgs.util-linux}/bin/flock -x 200

            mkdir -p ${esc config.absoluteDir}/.nixcraft

            if [ -f ${esc entryFilePath} ]; then
              while IFS= read -r f; do
                  rm -rf "$f"
                  rmdir --ignore-fail-on-non-empty "$(dirname "$f")" 2>/dev/null || true
              done < ${esc entryFilePath}
            fi

            cp ${newEntriesFile} ${esc entryFilePath}.tmp
            mv -f ${esc entryFilePath}.tmp ${esc entryFilePath}

            ${script'world}

            ${script'copy}

            ${script'symlink}

            ${script'merge}

            if [ ! -e ${esc initFilePath} ]; then
              ${script'copy-init}
              touch ${esc initFilePath}
            fi

            exec 200<&-
          '';
        }

        # Validations
        (let
          prefixMsg = "${config._instanceType} instance '${config.name}'";
        in {
          _module.check = lib.all (a: a) [
            # make sure that paths that are enabled don't have any children
            (
              let
                allPaths = lib.attrNames config.files;

                conflicts =
                  lib.filter (
                    path:
                      (config.files.${path}.enable or false)
                      == true
                      && (lib.any (p: p != path && lib.hasPrefix "${path}/" p) allPaths)
                  )
                  allPaths;

                conflictMessages =
                  map (
                    path: let
                      children = lib.filter (p: p != path && lib.hasPrefix "${path}/" p) allPaths;
                    in ''
                      files."${path}" is enabled but it also has children:
                        ${lib.concatStringsSep "\n  " children}
                    ''
                  )
                  conflicts;
              in
                lib.assertMsg (conflicts == [])
                ''
                  ${prefixMsg}: file path conflicts detected:

                  ${lib.concatStringsSep "\n\n" conflictMessages}
                ''
            )
          ];
        })
      ];
    })
  ];
}
