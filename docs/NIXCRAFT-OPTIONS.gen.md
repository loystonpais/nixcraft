## enable



Whether to enable nixcraft\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## activationShellScript

This option has no description\.



*Type:*
strings concatenated with “\\n”



## client



This option has no description\.



*Type:*
submodule



## client\.auth\.uuid



Default player UUID for client authentication\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```



## client\.dir



This option has no description\.



*Type:*
absolute path



*Default:*

```nix
"/(root)/.local/share/nixcraft/client/instances"
```



## client\.instances



This option has no description\.



*Type:*
attribute set of (submodule)



## client\.instances\.\<name>\.enable



Whether to enable client instance\.



*Type:*
boolean



*Default:*

```nix
true
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.enableDriPrime



Whether to enable dri prime (mesa)\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.enableExternalAssets



Whether to enable external asset management via fetchAssets script\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.enableNixGL



Whether to enable nixGL\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.enableNvidiaOffload



Whether to enable nvidia offload\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\._classSettings



This option has no description\.



*Type:*
submodule



## client\.instances\.\<name>\._classSettings\.assetIndex



This option has no description\.



*Type:*
non-empty string



## client\.instances\.\<name>\._classSettings\.assetsDir



This option has no description\.



*Type:*
absolute path



## client\.instances\.\<name>\._classSettings\.fullscreen



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```



## client\.instances\.\<name>\._classSettings\.gameDir



This option has no description\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```



## client\.instances\.\<name>\._classSettings\.height



This option has no description\.



*Type:*
null or (positive integer, meaning >0)



*Default:*

```nix
null
```



## client\.instances\.\<name>\._classSettings\.userProperties



This option has no description\.



*Type:*
null or (attribute set)



*Default:*

```nix
null
```



## client\.instances\.\<name>\._classSettings\.username



This option has no description\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```



## client\.instances\.\<name>\._classSettings\.uuid



This option has no description\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```



## client\.instances\.\<name>\._classSettings\.version



This option has no description\.



*Type:*
non-empty string



## client\.instances\.\<name>\._classSettings\.width



This option has no description\.



*Type:*
null or (positive integer, meaning >0)



*Default:*

```nix
null
```



## client\.instances\.\<name>\.absoluteDir



This option has no description\.



*Type:*
absolute path



*Default:*

```nix
"/(root)/.local/share/nixcraft/client/instances/‹name›"
```



## client\.instances\.\<name>\.account



This option has no description\.



*Type:*
null or (submodule)



*Default:*

```nix
null
```



## client\.instances\.\<name>\.account\.authDir



Path to nixcraft auth cache directory\.



*Type:*
string



*Default:*

```nix
"/(root)/.local/share/nixcraft/client/auth"
```



## client\.instances\.\<name>\.account\.offline



Whether this account is offline (unauthenticated)\.



*Type:*
boolean



*Default:*

```nix
false
```



## client\.instances\.\<name>\.account\.username



Player username\. For online accounts, used to verify against authenticated profile\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```



## client\.instances\.\<name>\.account\.uuid



Player UUID\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```



## client\.instances\.\<name>\.activationShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n”



*Default:*

```nix
""
```



## client\.instances\.\<name>\.binEntry



This option has no description\.



*Type:*
submodule



## client\.instances\.\<name>\.binEntry\.enable



Whether to enable bin entry\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.binEntry\.finalBin



This option has no description\.



*Type:*
package *(read only)*



*Default:*

```nix
<derivation nixcraft-client--name->
```



## client\.instances\.\<name>\.binEntry\.name



This option has no description\.



*Type:*
non-empty string



## client\.instances\.\<name>\.desktopEntry



This option has no description\.



*Type:*
submodule



*Default:*

```nix
{
  enable = false;
}
```



## client\.instances\.\<name>\.desktopEntry\.enable



Whether to enable desktop entry\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.desktopEntry\.extraConfig



This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```



## client\.instances\.\<name>\.desktopEntry\.name



This option has no description\.



*Type:*
non-empty string



*Default:*

```nix
"Nixcraft Instance ‹name›"
```



## client\.instances\.\<name>\.envVars



This option has no description\.



*Type:*
attribute set of (null or (list of (signed integer or string or absolute path)) or signed integer or string or absolute path)



*Default:*

```nix
{ }
```



*Example:*

```nix
{
  FOO = "BAR";
}
```



## client\.instances\.\<name>\.externalAssetDir



Path to external assets directory



*Type:*
null or absolute path



*Default:*

```nix
"/(root)/.local/share/nixcraft/client/assets"
```



## client\.instances\.\<name>\.externalAssetExtraLookupPaths



Extra paths to read/lookup cached assets from when fetching external assets\.



*Type:*
list of (string or absolute path)



*Default:*

```nix
[ ]
```



## client\.instances\.\<name>\.extraArguments



This option has no description\.



*Type:*
list of non-empty string



*Default:*

```nix
[ ]
```



## client\.instances\.\<name>\.fabricLoader



This option has no description\.



*Type:*
submodule



*Default:*

```nix
{
  _instanceType = "client";
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "26.2";
    priority = 1500;
  };
}
```



## client\.instances\.\<name>\.fabricLoader\.enable



Whether to enable fabric loader\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.fabricLoader\._impurePackage



This option has no description\.



*Type:*
package *(read only)*



*Default:*

```nix
"package"
```



## client\.instances\.\<name>\.fabricLoader\.classes



This option has no description\.



*Type:*
list of absolute path *(read only)*



*Default:*

```nix
[ ]
```



## client\.instances\.\<name>\.fabricLoader\.hash



This option has no description\.



*Type:*
non-empty string



## client\.instances\.\<name>\.fabricLoader\.meta



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"meta"
```



## client\.instances\.\<name>\.fabricLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



## client\.instances\.\<name>\.fabricLoader\.version



This option has no description\.



*Type:*
non-empty string



## client\.instances\.\<name>\.files



This option has no description\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```



## client\.instances\.\<name>\.files\.\<name>\.enable



Whether to enable ‹name›\.



*Type:*
boolean



*Default:*

```nix
true
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.files\.\<name>\.dirName



This option has no description\.



*Type:*
unspecified value *(read only)*



*Default:*

```nix
"."
```



## client\.instances\.\<name>\.files\.\<name>\.extraConfig



This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```



## client\.instances\.\<name>\.files\.\<name>\.fileName



This option has no description\.



*Type:*
unspecified value *(read only)*



*Default:*

```nix
"‹name›"
```



## client\.instances\.\<name>\.files\.\<name>\.finalSource



This option has no description\.



*Type:*
absolute path *(read only)*



## client\.instances\.\<name>\.files\.\<name>\.force



Overwrite previously existing file/symlink/dir



*Type:*
boolean



*Default:*

```nix
false
```



## client\.instances\.\<name>\.files\.\<name>\.method



Method to place the file in target location
copy-init     - copy once during init (suitable for config files from modpacks)
copy          - copy every rebuild
symlink       - symlink every rebuild
world         - recursive copy directory only if it doesn’t exist already (used internally for world/saves)



*Type:*
one of “copy”, “copy-init”, “symlink”, “world”



*Default:*

```nix
"symlink"
```



## client\.instances\.\<name>\.files\.\<name>\.source



This option has no description\.



*Type:*
null or absolute path



*Default:*

```nix
null
```



## client\.instances\.\<name>\.files\.\<name>\.target



This option has no description\.



*Type:*
relative path *(read only)*



*Default:*

```nix
"‹name›"
```



## client\.instances\.\<name>\.files\.\<name>\.text



This option has no description\.



*Type:*
null or string



*Default:*

```nix
null
```



## client\.instances\.\<name>\.files\.\<name>\.type



Type of the file\. This is used while converting passed value to the
desired file format\. This is totally optional and need NOT be set when \.source / \.text is defined
as it can cause unncesessary IFD (Import From Derivation)



*Type:*
null or one of “json”, “toml”, “yaml”, “ini”, “txt-list”, “properties”, “options-txt”



*Default:*

```nix
null
```



## client\.instances\.\<name>\.files\.\<name>\.value



A value that will be transformed to the desired format when \.type is set



*Type:*
(list of anything) or attribute set of anything or anything



## client\.instances\.\<name>\.finalActivationShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*



## client\.instances\.\<name>\.finalArgumentShellString



This option has no description\.



*Type:*
non-empty string *(read only)*



*Default:*

```nix
"--version 26.2 --assetsDir /nix/store/cc8whj1ggbwlr9wpgf4xzhlf1132p7pq-minecraft-asset-dir --assetIndex 32 --gameDir '/(root)/.local/share/nixcraft/client/instances/‹name›'"
```



## client\.instances\.\<name>\.finalFilePlacementShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*



## client\.instances\.\<name>\.finalLaunchShellCommandString



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*



## client\.instances\.\<name>\.finalLaunchShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*



## client\.instances\.\<name>\.finalPreLaunchShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*



## client\.instances\.\<name>\.forgeLoader



This option has no description\.



*Type:*
submodule



*Default:*

```nix
{
  _instanceType = "client";
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "26.2";
    priority = 1500;
  };
}
```



## client\.instances\.\<name>\.forgeLoader\.enable



Whether to enable forge loader\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.forgeLoader\.hash



This option has no description\.



*Type:*
non-empty string



*Default:*

```nix
"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
```



## client\.instances\.\<name>\.forgeLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



## client\.instances\.\<name>\.forgeLoader\.parsedForgeLoader



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"parsedForgeLoader"
```



## client\.instances\.\<name>\.forgeLoader\.version



This option has no description\.



*Type:*
non-empty string



## client\.instances\.\<name>\.java



This option has no description\.



*Type:*
submodule



## client\.instances\.\<name>\.java\.package



This option has no description\.



*Type:*
package



## client\.instances\.\<name>\.java\.D



Java system properties (-D flags) to pass to the JVM\.



*Type:*
attribute set of (string or absolute path or package or signed integer or boolean or floating point number)



*Default:*

```nix
{ }
```



## client\.instances\.\<name>\.java\.cp



This option has no description\.



*Type:*
list of absolute path



*Default:*

```nix
[ ]
```



## client\.instances\.\<name>\.java\.extraArguments



This option has no description\.



*Type:*
list of non-empty string



*Default:*

```nix
[ ]
```



## client\.instances\.\<name>\.java\.finalArgumentShellString



This option has no description\.



*Type:*
non-empty string *(read only)*



*Default:*

```nix
""
```



## client\.instances\.\<name>\.java\.finalArguments



This option has no description\.



*Type:*
list of string *(read only)*



*Default:*

```nix
[ ]
```



## client\.instances\.\<name>\.java\.jar



This option has no description\.



*Type:*
null or absolute path



*Default:*

```nix
null
```



## client\.instances\.\<name>\.java\.mainClass



This option has no description\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```



## client\.instances\.\<name>\.java\.maxMemory



This option has no description\.



*Type:*
null or (Java memory size (in MBs))



*Default:*

```nix
null
```



## client\.instances\.\<name>\.java\.memory



This option has no description\.



*Type:*
null or (Java memory size (in MBs))



*Default:*

```nix
null
```



## client\.instances\.\<name>\.java\.minMemory



This option has no description\.



*Type:*
null or (Java memory size (in MBs))



*Default:*

```nix
null
```



## client\.instances\.\<name>\.jemalloc\.enable



Whether to enable jemalloc\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.libraries



This option has no description\.



*Type:*
list of (attribute set)



*Default:*

```nix
[ ]
```



## client\.instances\.\<name>\.mainJar



This option has no description\.



*Type:*
absolute path



## client\.instances\.\<name>\.meta\.versionData



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"versionData"
```



## client\.instances\.\<name>\.mrpack



This option has no description\.



*Type:*
submodule



*Default:*

```nix
{
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "26.2";
    priority = 1500;
  };
}
```



## client\.instances\.\<name>\.mrpack\.enable



Whether to enable enable mrpack\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.mrpack\.enableOptionalMods



Whether to enable optional mods\.



*Type:*
boolean



*Default:*

```nix
true
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.mrpack\._parsedMrpack



This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```



## client\.instances\.\<name>\.mrpack\.fabricLoaderVersion



This option has no description\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```



## client\.instances\.\<name>\.mrpack\.file



This option has no description\.



*Type:*
package



## client\.instances\.\<name>\.mrpack\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



## client\.instances\.\<name>\.mrpack\.placeOverrides



Whether to enable placing overrides\.



*Type:*
boolean



*Default:*

```nix
true
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.mrpack\.quiltLoaderVersion



This option has no description\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```



## client\.instances\.\<name>\.placeFilesAtActivation



Whether to enable placing files during activation\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.preLaunchShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n”



*Default:*

```nix
""
```



## client\.instances\.\<name>\.quiltLoader

This option has no description\.



*Type:*
submodule



*Default:*

```nix
{
  _instanceType = "client";
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "26.2";
    priority = 1500;
  };
}
```



## client\.instances\.\<name>\.quiltLoader\.enable



Whether to enable quilt loader\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.quiltLoader\.classes



This option has no description\.



*Type:*
list of absolute path *(read only)*



*Default:*

```nix
[ ]
```



## client\.instances\.\<name>\.quiltLoader\.hash



This option has no description\.



*Type:*
non-empty string



## client\.instances\.\<name>\.quiltLoader\.meta



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"meta"
```



## client\.instances\.\<name>\.quiltLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



## client\.instances\.\<name>\.quiltLoader\.version



This option has no description\.



*Type:*
non-empty string



## client\.instances\.\<name>\.renice\.enable



Whether to enable renicing the instance process before launch\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.renice\.priority



Niceness priority value (between -20 and 19)\. Lower values mean higher priority\.



*Type:*
signed integer



*Default:*

```nix
-20
```



## client\.instances\.\<name>\.renice\.sudoLookupPaths



This option has no description\.



*Type:*
list of absolute path



*Default:*

```nix
[
  "/run/wrappers/bin/sudo"
  "/usr/bin/sudo"
  "/bin/sudo"
]
```



## client\.instances\.\<name>\.renice\.wrappedBinPath



This option has no description\.



*Type:*
absolute path



*Default:*

```nix
"/run/wrappers/bin/nixcraft-renice"
```



## client\.instances\.\<name>\.runtimeLibs



Libraries available at runtime



*Type:*
list of absolute path



*Default:*

```nix
[ ]
```



## client\.instances\.\<name>\.runtimePrograms



This option has no description\.



*Type:*
list of absolute path



*Default:*

```nix
[ ]
```



## client\.instances\.\<name>\.saves



World saves\. Placed only if the directory already doesn’t exist
{
“My World” = /path/to/world
}



*Type:*
attribute set of absolute path



*Default:*

```nix
{ }
```



## client\.instances\.\<name>\.useDiscreteGPU



Whether to enable discrete GPU\.



*Type:*
boolean



*Default:*

```nix
true
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.version



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



*Default:*

```nix
"latest-release"
```



## client\.instances\.\<name>\.waywall



This option has no description\.



*Type:*
submodule



## client\.instances\.\<name>\.waywall\.enable



Whether to enable waywall\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## client\.instances\.\<name>\.waywall\.package



This option has no description\.



*Type:*
package



## client\.instances\.\<name>\.waywall\.configDir



Path to a dir containing waywall scripts such as init\.lua
If not set then $XDG_CONFIG_HOME/waywall is used as usual



*Type:*
null or absolute path



*Default:*

```nix
null
```



*Example:*

```nix
''
  pkgs.linkFarm {
    "init.lua" = builtins.toFile "init.lua" "<content>";
  };
''
```



## client\.instances\.\<name>\.waywall\.configText



Lua script passed as init\.lua



*Type:*
null or non-empty string



*Default:*

```nix
null
```



## client\.instances\.\<name>\.waywall\.profile



This option has no description\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```



*Example:*

```nix
"foo"
```



## client\.shared



This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```



## finalActivationShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*



## server



This option has no description\.



*Type:*
submodule



## server\.dir



This option has no description\.



*Type:*
absolute path



*Default:*

```nix
"/(root)/.local/share/nixcraft/server/instances"
```



## server\.instances



This option has no description\.



*Type:*
attribute set of (submodule)



## server\.instances\.\<name>\.enable



Whether to enable server instance\.



*Type:*
boolean



*Default:*

```nix
true
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.absoluteDir



This option has no description\.



*Type:*
absolute path



*Default:*

```nix
"/(root)/.local/share/nixcraft/server/instances/‹name›"
```



## server\.instances\.\<name>\.activationShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n”



*Default:*

```nix
""
```



## server\.instances\.\<name>\.agreeToEula



Whether to enable agree to EULA\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.binEntry



This option has no description\.



*Type:*
submodule



## server\.instances\.\<name>\.binEntry\.enable



Whether to enable bin entry\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.binEntry\.finalBin



This option has no description\.



*Type:*
package *(read only)*



*Default:*

```nix
<derivation nixcraft-server--name->
```



## server\.instances\.\<name>\.binEntry\.name



This option has no description\.



*Type:*
non-empty string



## server\.instances\.\<name>\.envVars



This option has no description\.



*Type:*
attribute set of (null or (list of (signed integer or string or absolute path)) or signed integer or string or absolute path)



*Default:*

```nix
{ }
```



*Example:*

```nix
{
  FOO = "BAR";
}
```



## server\.instances\.\<name>\.extraArguments



This option has no description\.



*Type:*
list of non-empty string



*Default:*

```nix
[ ]
```



## server\.instances\.\<name>\.fabricLoader



This option has no description\.



*Type:*
submodule



*Default:*

```nix
{
  _instanceType = "server";
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "26.2";
    priority = 1500;
  };
}
```



## server\.instances\.\<name>\.fabricLoader\.enable



Whether to enable fabric loader\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.fabricLoader\._impurePackage



This option has no description\.



*Type:*
package *(read only)*



*Default:*

```nix
"package"
```



## server\.instances\.\<name>\.fabricLoader\.classes



This option has no description\.



*Type:*
list of absolute path *(read only)*



*Default:*

```nix
[ ]
```



## server\.instances\.\<name>\.fabricLoader\.hash



This option has no description\.



*Type:*
non-empty string



## server\.instances\.\<name>\.fabricLoader\.meta



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"meta"
```



## server\.instances\.\<name>\.fabricLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



## server\.instances\.\<name>\.fabricLoader\.version



This option has no description\.



*Type:*
non-empty string



## server\.instances\.\<name>\.files



This option has no description\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```



## server\.instances\.\<name>\.files\.\<name>\.enable



Whether to enable ‹name›\.



*Type:*
boolean



*Default:*

```nix
true
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.files\.\<name>\.dirName



This option has no description\.



*Type:*
unspecified value *(read only)*



*Default:*

```nix
"."
```



## server\.instances\.\<name>\.files\.\<name>\.extraConfig



This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```



## server\.instances\.\<name>\.files\.\<name>\.fileName



This option has no description\.



*Type:*
unspecified value *(read only)*



*Default:*

```nix
"‹name›"
```



## server\.instances\.\<name>\.files\.\<name>\.finalSource



This option has no description\.



*Type:*
absolute path *(read only)*



## server\.instances\.\<name>\.files\.\<name>\.force



Overwrite previously existing file/symlink/dir



*Type:*
boolean



*Default:*

```nix
false
```



## server\.instances\.\<name>\.files\.\<name>\.method



Method to place the file in target location
copy-init     - copy once during init (suitable for config files from modpacks)
copy          - copy every rebuild
symlink       - symlink every rebuild
world         - recursive copy directory only if it doesn’t exist already (used internally for world/saves)



*Type:*
one of “copy”, “copy-init”, “symlink”, “world”



*Default:*

```nix
"symlink"
```



## server\.instances\.\<name>\.files\.\<name>\.source



This option has no description\.



*Type:*
null or absolute path



*Default:*

```nix
null
```



## server\.instances\.\<name>\.files\.\<name>\.target



This option has no description\.



*Type:*
relative path *(read only)*



*Default:*

```nix
"‹name›"
```



## server\.instances\.\<name>\.files\.\<name>\.text



This option has no description\.



*Type:*
null or string



*Default:*

```nix
null
```



## server\.instances\.\<name>\.files\.\<name>\.type



Type of the file\. This is used while converting passed value to the
desired file format\. This is totally optional and need NOT be set when \.source / \.text is defined
as it can cause unncesessary IFD (Import From Derivation)



*Type:*
null or one of “json”, “toml”, “yaml”, “ini”, “txt-list”, “properties”, “options-txt”



*Default:*

```nix
null
```



## server\.instances\.\<name>\.files\.\<name>\.value



A value that will be transformed to the desired format when \.type is set



*Type:*
(list of anything) or attribute set of anything or anything



## server\.instances\.\<name>\.finalActivationShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*



## server\.instances\.\<name>\.finalArgumentShellString



This option has no description\.



*Type:*
string *(read only)*



*Default:*

```nix
"nogui"
```



## server\.instances\.\<name>\.finalFilePlacementShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*



## server\.instances\.\<name>\.finalLaunchShellCommandString



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*



## server\.instances\.\<name>\.finalLaunchShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*



## server\.instances\.\<name>\.finalPreLaunchShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*



## server\.instances\.\<name>\.forgeLoader



This option has no description\.



*Type:*
submodule



*Default:*

```nix
{
  _instanceType = "server";
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "26.2";
    priority = 1500;
  };
}
```



## server\.instances\.\<name>\.forgeLoader\.enable



Whether to enable forge loader\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.forgeLoader\.hash



This option has no description\.



*Type:*
non-empty string



*Default:*

```nix
"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
```



## server\.instances\.\<name>\.forgeLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



## server\.instances\.\<name>\.forgeLoader\.parsedForgeLoader



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"parsedForgeLoader"
```



## server\.instances\.\<name>\.forgeLoader\.version



This option has no description\.



*Type:*
non-empty string



## server\.instances\.\<name>\.java



This option has no description\.



*Type:*
submodule



## server\.instances\.\<name>\.java\.package



This option has no description\.



*Type:*
package



## server\.instances\.\<name>\.java\.D



Java system properties (-D flags) to pass to the JVM\.



*Type:*
attribute set of (string or absolute path or package or signed integer or boolean or floating point number)



*Default:*

```nix
{ }
```



## server\.instances\.\<name>\.java\.cp



This option has no description\.



*Type:*
list of absolute path



*Default:*

```nix
[ ]
```



## server\.instances\.\<name>\.java\.extraArguments



This option has no description\.



*Type:*
list of non-empty string



*Default:*

```nix
[ ]
```



## server\.instances\.\<name>\.java\.finalArgumentShellString



This option has no description\.



*Type:*
non-empty string *(read only)*



*Default:*

```nix
""
```



## server\.instances\.\<name>\.java\.finalArguments



This option has no description\.



*Type:*
list of string *(read only)*



*Default:*

```nix
[ ]
```



## server\.instances\.\<name>\.java\.jar



This option has no description\.



*Type:*
null or absolute path



*Default:*

```nix
null
```



## server\.instances\.\<name>\.java\.mainClass



This option has no description\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```



## server\.instances\.\<name>\.java\.maxMemory



This option has no description\.



*Type:*
null or (Java memory size (in MBs))



*Default:*

```nix
null
```



## server\.instances\.\<name>\.java\.memory



This option has no description\.



*Type:*
null or (Java memory size (in MBs))



*Default:*

```nix
null
```



## server\.instances\.\<name>\.java\.minMemory



This option has no description\.



*Type:*
null or (Java memory size (in MBs))



*Default:*

```nix
null
```



## server\.instances\.\<name>\.jemalloc\.enable



Whether to enable jemalloc\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.lazymc



This option has no description\.



*Type:*
submodule



## server\.instances\.\<name>\.lazymc\.enable



Whether to enable lazymc\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.lazymc\.package



This option has no description\.



*Type:*
package



*Default:*

```nix
<derivation lazymc-0.2.11>
```



## server\.instances\.\<name>\.lazymc\.settings



This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```



## server\.instances\.\<name>\.libraries



This option has no description\.



*Type:*
list of (attribute set)



*Default:*

```nix
[ ]
```



## server\.instances\.\<name>\.mainJar



This option has no description\.



*Type:*
absolute path



## server\.instances\.\<name>\.meta\.versionData



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"versionData"
```



## server\.instances\.\<name>\.mrpack



This option has no description\.



*Type:*
submodule



*Default:*

```nix
{
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "26.2";
    priority = 1500;
  };
}
```



## server\.instances\.\<name>\.mrpack\.enable



Whether to enable enable mrpack\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.mrpack\.enableOptionalMods



Whether to enable optional mods\.



*Type:*
boolean



*Default:*

```nix
true
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.mrpack\._parsedMrpack



This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```



## server\.instances\.\<name>\.mrpack\.fabricLoaderVersion



This option has no description\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```



## server\.instances\.\<name>\.mrpack\.file



This option has no description\.



*Type:*
package



## server\.instances\.\<name>\.mrpack\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



## server\.instances\.\<name>\.mrpack\.placeOverrides



Whether to enable placing overrides\.



*Type:*
boolean



*Default:*

```nix
true
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.mrpack\.quiltLoaderVersion



This option has no description\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```



## server\.instances\.\<name>\.noGui

Whether to enable no gui\.



*Type:*
boolean



*Default:*

```nix
true
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.paper



This option has no description\.



*Type:*
submodule



*Default:*

```nix
{
  enable = false;
}
```



## server\.instances\.\<name>\.paper\.enable



Whether to enable paper\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.paper\._mainClass



This option has no description\.



*Type:*
non-empty string *(read only)*



*Default:*

```nix
"<inferred>"
```



## server\.instances\.\<name>\.paper\._serverJar



This option has no description\.



*Type:*
package *(read only)*



*Default:*

```nix
"serverJar"
```



## server\.instances\.\<name>\.paper\.buildNumber



This option has no description\.



*Type:*
non-empty string



*Default:*

```nix
"<inferred>"
```



## server\.instances\.\<name>\.paper\.meta



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"meta"
```



## server\.instances\.\<name>\.paper\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



*Default:*

```nix
"<inferred>"
```



## server\.instances\.\<name>\.placeFilesAtActivation



Whether to enable placing files during activation\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.preLaunchShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n”



*Default:*

```nix
""
```



## server\.instances\.\<name>\.quiltLoader



This option has no description\.



*Type:*
submodule



*Default:*

```nix
{
  _instanceType = "server";
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "26.2";
    priority = 1500;
  };
}
```



## server\.instances\.\<name>\.quiltLoader\.enable



Whether to enable quilt loader\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.quiltLoader\.classes



This option has no description\.



*Type:*
list of absolute path *(read only)*



*Default:*

```nix
[ ]
```



## server\.instances\.\<name>\.quiltLoader\.hash



This option has no description\.



*Type:*
non-empty string



## server\.instances\.\<name>\.quiltLoader\.meta



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"meta"
```



## server\.instances\.\<name>\.quiltLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



## server\.instances\.\<name>\.quiltLoader\.version



This option has no description\.



*Type:*
non-empty string



## server\.instances\.\<name>\.renice\.enable



Whether to enable renicing the instance process before launch\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.renice\.priority



Niceness priority value (between -20 and 19)\. Lower values mean higher priority\.



*Type:*
signed integer



*Default:*

```nix
-20
```



## server\.instances\.\<name>\.renice\.sudoLookupPaths



This option has no description\.



*Type:*
list of absolute path



*Default:*

```nix
[
  "/run/wrappers/bin/sudo"
  "/usr/bin/sudo"
  "/bin/sudo"
]
```



## server\.instances\.\<name>\.renice\.wrappedBinPath



This option has no description\.



*Type:*
absolute path



*Default:*

```nix
"/run/wrappers/bin/nixcraft-renice"
```



## server\.instances\.\<name>\.runtimeLibs



Libraries available at runtime



*Type:*
list of absolute path



*Default:*

```nix
[ ]
```



## server\.instances\.\<name>\.runtimePrograms



This option has no description\.



*Type:*
list of absolute path



*Default:*

```nix
[ ]
```



## server\.instances\.\<name>\.serverProperties



This option has no description\.



*Type:*
null or (attribute set of (null or boolean or signed integer or string))



*Default:*

```nix
null
```



## server\.instances\.\<name>\.service



This option has no description\.



*Type:*
submodule



*Default:*

```nix
{
  autoStart = true;
  enable = false;
}
```



## server\.instances\.\<name>\.service\.enable



Whether to enable systemd user service\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.service\.autoStart



Whether to enable enables by default\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```



## server\.instances\.\<name>\.version



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



*Default:*

```nix
"latest-release"
```



## server\.instances\.\<name>\.world



Path to world dir\. Only placed if the directory doesn’t exist



*Type:*
null or absolute path



*Default:*

```nix
null
```



## server\.shared



This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```


