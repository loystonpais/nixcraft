## enable



Whether to enable nixcraft\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## activationShellScript

This option has no description\.



*Type:*
strings concatenated with “\\n”



## client



This option has no description\.



*Type:*
submodule



## client\.accounts



This option has no description\.



*Type:*
attribute set of (submodule)



*Default:*
` { } `



## client\.accounts\.\<name>\.accessTokenPath



This option has no description\.



*Type:*
null or non-empty string



*Default:*
` null `



## client\.accounts\.\<name>\.offline



This option has no description\.



*Type:*
boolean



*Default:*
` false `



## client\.accounts\.\<name>\.username



This option has no description\.



*Type:*
non-empty string



*Default:*
` "‹name›" `



## client\.accounts\.\<name>\.uuid



This option has no description\.



*Type:*
null or non-empty string



*Default:*
` null `



## client\.dir



This option has no description\.



*Type:*
absolute path



*Default:*
` "/(root)/.local/share/nixcraft/client/instances" `



## client\.instances



This option has no description\.



*Type:*
attribute set of (submodule)



## client\.instances\.\<name>\.enable



Whether to enable client instance\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## client\.instances\.\<name>\.enableDriPrime



Whether to enable dri prime (mesa)\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## client\.instances\.\<name>\.enableNvidiaOffload



Whether to enable nvidia offload\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



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
` false `



## client\.instances\.\<name>\._classSettings\.gameDir



This option has no description\.



*Type:*
null or non-empty string



*Default:*
` null `



## client\.instances\.\<name>\._classSettings\.height



This option has no description\.



*Type:*
null or (positive integer, meaning >0)



*Default:*
` null `



## client\.instances\.\<name>\._classSettings\.userProperties



This option has no description\.



*Type:*
null or (attribute set)



*Default:*
` null `



## client\.instances\.\<name>\._classSettings\.username



This option has no description\.



*Type:*
null or non-empty string



*Default:*
` null `



## client\.instances\.\<name>\._classSettings\.uuid



This option has no description\.



*Type:*
null or non-empty string



*Default:*
` null `



## client\.instances\.\<name>\._classSettings\.version



This option has no description\.



*Type:*
non-empty string



## client\.instances\.\<name>\._classSettings\.width



This option has no description\.



*Type:*
null or (positive integer, meaning >0)



*Default:*
` null `



## client\.instances\.\<name>\.absoluteDir



This option has no description\.



*Type:*
absolute path



*Default:*
` "/(root)/.local/share/nixcraft/client/instances/‹name›" `



## client\.instances\.\<name>\.account



This option has no description\.



*Type:*
null or (submodule)



*Default:*
` null `



## client\.instances\.\<name>\.account\.accessTokenPath



This option has no description\.



*Type:*
null or non-empty string



*Default:*
` null `



## client\.instances\.\<name>\.account\.offline



This option has no description\.



*Type:*
boolean



*Default:*
` false `



## client\.instances\.\<name>\.account\.username



This option has no description\.



*Type:*
non-empty string



*Default:*
` "‹name›" `



## client\.instances\.\<name>\.account\.uuid



This option has no description\.



*Type:*
null or non-empty string



*Default:*
` null `



## client\.instances\.\<name>\.activationShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n”



*Default:*
` "" `



## client\.instances\.\<name>\.binEntry



This option has no description\.



*Type:*
submodule



## client\.instances\.\<name>\.binEntry\.enable



Whether to enable bin entry\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## client\.instances\.\<name>\.binEntry\.finalBin



This option has no description\.



*Type:*
package *(read only)*



*Default:*
` <derivation nixcraft-client--name-> `



## client\.instances\.\<name>\.binEntry\.name



This option has no description\.



*Type:*
non-empty string



## client\.instances\.\<name>\.desktopEntry



This option has no description\.



*Type:*
submodule



*Default:*

```
{
  enable = false;
}
```



## client\.instances\.\<name>\.desktopEntry\.enable



Whether to enable desktop entry\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## client\.instances\.\<name>\.desktopEntry\.extraConfig



This option has no description\.



*Type:*
attribute set



*Default:*
` { } `



## client\.instances\.\<name>\.desktopEntry\.name



This option has no description\.



*Type:*
non-empty string



*Default:*
` "Nixcraft Instance ‹name›" `



## client\.instances\.\<name>\.envVars



This option has no description\.



*Type:*
attribute set of (null or (list of (signed integer or string or absolute path)) or signed integer or string or absolute path)



*Default:*
` { } `



*Example:*

```
{
  FOO = "BAR";
}
```



## client\.instances\.\<name>\.extraArguments



This option has no description\.



*Type:*
list of non-empty string



*Default:*
` [ ] `



## client\.instances\.\<name>\.fabricLoader



This option has no description\.



*Type:*
submodule



*Default:*

```
{
  _instanceType = "client";
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "1.21.10";
    priority = 1500;
  };
}
```



## client\.instances\.\<name>\.fabricLoader\.enable



Whether to enable fabric loader\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## client\.instances\.\<name>\.fabricLoader\._impurePackage



This option has no description\.



*Type:*
package *(read only)*



*Default:*
` "package" `



## client\.instances\.\<name>\.fabricLoader\.classes



This option has no description\.



*Type:*
list of absolute path *(read only)*



## client\.instances\.\<name>\.fabricLoader\.hash



This option has no description\.



*Type:*
non-empty string



## client\.instances\.\<name>\.fabricLoader\.meta



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*
` "meta" `



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
` { } `



## client\.instances\.\<name>\.files\.\<name>\.enable



Whether to enable ‹name›\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `



## client\.instances\.\<name>\.files\.\<name>\.dirName



This option has no description\.



*Type:*
unspecified value *(read only)*



*Default:*
` "." `



## client\.instances\.\<name>\.files\.\<name>\.extraConfig



This option has no description\.



*Type:*
attribute set



*Default:*
` { } `



## client\.instances\.\<name>\.files\.\<name>\.fileName



This option has no description\.



*Type:*
unspecified value *(read only)*



*Default:*
` "‹name›" `



## client\.instances\.\<name>\.files\.\<name>\.finalSource



This option has no description\.



*Type:*
absolute path *(read only)*



## client\.instances\.\<name>\.files\.\<name>\.force



Overwrite previously existing file/symlink/dir



*Type:*
boolean



*Default:*
` false `



## client\.instances\.\<name>\.files\.\<name>\.method



Method to place the file in target location
copy-init     - copy once during init (suitable for config files from modpacks)
copy          - copy every rebuild
symlink - symlink every rebuild



*Type:*
one of “copy”, “copy-init”, “symlink”



*Default:*
` "symlink" `



## client\.instances\.\<name>\.files\.\<name>\.source



This option has no description\.



*Type:*
null or absolute path



*Default:*
` null `



## client\.instances\.\<name>\.files\.\<name>\.target



This option has no description\.



*Type:*
relative path



*Default:*
` "‹name›" `



## client\.instances\.\<name>\.files\.\<name>\.text



This option has no description\.



*Type:*
null or string



*Default:*
` null `



## client\.instances\.\<name>\.files\.\<name>\.type



Type of the file\. This is used while converting passed value to the
desired file format\. This is totally optional and need NOT be set when \.source / \.text is defined
as it can cause unncesessary IFD (Import From Derivation)



*Type:*
null or one of “json”, “toml”, “yaml”, “ini”, “txt-list”, “properties”, “options-txt”



*Default:*
` null `



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
` "--version 1.21.10 --assetsDir /nix/store/90016v5nsqq5mk93jj7naxiyng1x8gxn-minecraft-asset-dir --assetIndex 27 --gameDir '/(root)/.local/share/nixcraft/client/instances/‹name›'" `



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

```
{
  _instanceType = "client";
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "1.21.10";
    priority = 1500;
  };
}
```



## client\.instances\.\<name>\.forgeLoader\.enable



Whether to enable forge loader\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## client\.instances\.\<name>\.forgeLoader\.hash



This option has no description\.



*Type:*
non-empty string



*Default:*
` "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" `



## client\.instances\.\<name>\.forgeLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



## client\.instances\.\<name>\.forgeLoader\.parsedForgeLoader



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*
` "parsedForgeLoader" `



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



## client\.instances\.\<name>\.java\.cp



This option has no description\.



*Type:*
list of absolute path



*Default:*
` [ ] `



## client\.instances\.\<name>\.java\.extraArguments



This option has no description\.



*Type:*
list of non-empty string



*Default:*
` [ ] `



## client\.instances\.\<name>\.java\.finalArgumentShellString



This option has no description\.



*Type:*
non-empty string *(read only)*



*Default:*
` "" `



## client\.instances\.\<name>\.java\.finalArguments



This option has no description\.



*Type:*
list of string *(read only)*



*Default:*
` [ ] `



## client\.instances\.\<name>\.java\.jar



This option has no description\.



*Type:*
null or absolute path



*Default:*
` null `



## client\.instances\.\<name>\.java\.mainClass



This option has no description\.



*Type:*
null or non-empty string



*Default:*
` null `



## client\.instances\.\<name>\.java\.maxMemory



This option has no description\.



*Type:*
null or (Java memory size (in MBs))



*Default:*
` null `



## client\.instances\.\<name>\.java\.memory



This option has no description\.



*Type:*
null or (Java memory size (in MBs))



*Default:*
` null `



## client\.instances\.\<name>\.java\.minMemory



This option has no description\.



*Type:*
null or (Java memory size (in MBs))



*Default:*
` null `



## client\.instances\.\<name>\.libraries



This option has no description\.



*Type:*
list of (attribute set)



*Default:*
` [ ] `



## client\.instances\.\<name>\.mainJar



This option has no description\.



*Type:*
absolute path



## client\.instances\.\<name>\.meta\.versionData



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*
` "versionData" `



## client\.instances\.\<name>\.mrpack



This option has no description\.



*Type:*
submodule



*Default:*

```
{
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "1.21.10";
    priority = 1500;
  };
}
```



## client\.instances\.\<name>\.mrpack\.enable



Whether to enable enable mrpack\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## client\.instances\.\<name>\.mrpack\.enableOptionalMods



Whether to enable optional mods\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `



## client\.instances\.\<name>\.mrpack\._parsedMrpack



This option has no description\.



*Type:*
attribute set



## client\.instances\.\<name>\.mrpack\.fabricLoaderVersion



This option has no description\.



*Type:*
null or non-empty string



## client\.instances\.\<name>\.mrpack\.file



This option has no description\.



*Type:*
package



## client\.instances\.\<name>\.mrpack\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



## client\.instances\.\<name>\.mrpack\.mutableOverrides



Whether to enable mutable overrides\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `



## client\.instances\.\<name>\.mrpack\.placeOverrides



Whether to enable placing overrides\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `



## client\.instances\.\<name>\.mrpack\.quiltLoaderVersion



This option has no description\.



*Type:*
null or non-empty string



## client\.instances\.\<name>\.placeFilesAtActivation



Whether to enable placing files during activation\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## client\.instances\.\<name>\.preLaunchShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n”



*Default:*
` "" `



## client\.instances\.\<name>\.quiltLoader



This option has no description\.



*Type:*
submodule



*Default:*

```
{
  _instanceType = "client";
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "1.21.10";
    priority = 1500;
  };
}
```



## client\.instances\.\<name>\.quiltLoader\.enable



Whether to enable quilt loader\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## client\.instances\.\<name>\.quiltLoader\.classes

This option has no description\.



*Type:*
list of absolute path *(read only)*



## client\.instances\.\<name>\.quiltLoader\.hash



This option has no description\.



*Type:*
non-empty string



## client\.instances\.\<name>\.quiltLoader\.meta



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*
` "meta" `



## client\.instances\.\<name>\.quiltLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



## client\.instances\.\<name>\.quiltLoader\.version



This option has no description\.



*Type:*
non-empty string



## client\.instances\.\<name>\.runtimeLibs



Libraries available at runtime



*Type:*
list of absolute path



*Default:*
` [ ] `



## client\.instances\.\<name>\.runtimePrograms



This option has no description\.



*Type:*
list of absolute path



*Default:*
` [ ] `



## client\.instances\.\<name>\.saves



World saves\. Placed only if the directory already doesn’t exist
{
“My World” = /path/to/world
}



*Type:*
attribute set of absolute path



*Default:*
` { } `



## client\.instances\.\<name>\.useDiscreteGPU



Whether to enable discrete GPU\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `



## client\.instances\.\<name>\.version



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



*Default:*
` "latest-release" `



## client\.instances\.\<name>\.waywall



This option has no description\.



*Type:*
submodule



## client\.instances\.\<name>\.waywall\.enable



Whether to enable waywall\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



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
` null `



*Example:*

```
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
` null `



## client\.instances\.\<name>\.waywall\.profile



This option has no description\.



*Type:*
null or non-empty string



*Default:*
` null `



*Example:*
` "foo" `



## client\.shared



This option has no description\.



*Type:*
attribute set



*Default:*
` { } `



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
` "/(root)/.local/share/nixcraft/server/instances" `



## server\.instances



This option has no description\.



*Type:*
attribute set of (submodule)



## server\.instances\.\<name>\.enable



Whether to enable server instance\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## server\.instances\.\<name>\.absoluteDir



This option has no description\.



*Type:*
absolute path



*Default:*
` "/(root)/.local/share/nixcraft/server/instances/‹name›" `



## server\.instances\.\<name>\.activationShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n”



*Default:*
` "" `



## server\.instances\.\<name>\.agreeToEula



Whether to enable agree to EULA\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## server\.instances\.\<name>\.binEntry



This option has no description\.



*Type:*
submodule



## server\.instances\.\<name>\.binEntry\.enable



Whether to enable bin entry\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## server\.instances\.\<name>\.binEntry\.finalBin



This option has no description\.



*Type:*
package *(read only)*



*Default:*
` <derivation nixcraft-server--name-> `



## server\.instances\.\<name>\.binEntry\.name



This option has no description\.



*Type:*
non-empty string



## server\.instances\.\<name>\.envVars



This option has no description\.



*Type:*
attribute set of (null or (list of (signed integer or string or absolute path)) or signed integer or string or absolute path)



*Default:*
` { } `



*Example:*

```
{
  FOO = "BAR";
}
```



## server\.instances\.\<name>\.extraArguments



This option has no description\.



*Type:*
list of non-empty string



*Default:*
` [ ] `



## server\.instances\.\<name>\.fabricLoader



This option has no description\.



*Type:*
submodule



*Default:*

```
{
  _instanceType = "server";
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "1.21.10";
    priority = 1500;
  };
}
```



## server\.instances\.\<name>\.fabricLoader\.enable



Whether to enable fabric loader\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## server\.instances\.\<name>\.fabricLoader\._impurePackage



This option has no description\.



*Type:*
package *(read only)*



*Default:*
` "package" `



## server\.instances\.\<name>\.fabricLoader\.classes



This option has no description\.



*Type:*
list of absolute path *(read only)*



## server\.instances\.\<name>\.fabricLoader\.hash



This option has no description\.



*Type:*
non-empty string



## server\.instances\.\<name>\.fabricLoader\.meta



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*
` "meta" `



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
` { } `



## server\.instances\.\<name>\.files\.\<name>\.enable



Whether to enable ‹name›\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `



## server\.instances\.\<name>\.files\.\<name>\.dirName



This option has no description\.



*Type:*
unspecified value *(read only)*



*Default:*
` "." `



## server\.instances\.\<name>\.files\.\<name>\.extraConfig



This option has no description\.



*Type:*
attribute set



*Default:*
` { } `



## server\.instances\.\<name>\.files\.\<name>\.fileName



This option has no description\.



*Type:*
unspecified value *(read only)*



*Default:*
` "‹name›" `



## server\.instances\.\<name>\.files\.\<name>\.finalSource



This option has no description\.



*Type:*
absolute path *(read only)*



## server\.instances\.\<name>\.files\.\<name>\.force



Overwrite previously existing file/symlink/dir



*Type:*
boolean



*Default:*
` false `



## server\.instances\.\<name>\.files\.\<name>\.method



Method to place the file in target location
copy-init     - copy once during init (suitable for config files from modpacks)
copy          - copy every rebuild
symlink - symlink every rebuild



*Type:*
one of “copy”, “copy-init”, “symlink”



*Default:*
` "symlink" `



## server\.instances\.\<name>\.files\.\<name>\.source



This option has no description\.



*Type:*
null or absolute path



*Default:*
` null `



## server\.instances\.\<name>\.files\.\<name>\.target



This option has no description\.



*Type:*
relative path



*Default:*
` "‹name›" `



## server\.instances\.\<name>\.files\.\<name>\.text



This option has no description\.



*Type:*
null or string



*Default:*
` null `



## server\.instances\.\<name>\.files\.\<name>\.type



Type of the file\. This is used while converting passed value to the
desired file format\. This is totally optional and need NOT be set when \.source / \.text is defined
as it can cause unncesessary IFD (Import From Derivation)



*Type:*
null or one of “json”, “toml”, “yaml”, “ini”, “txt-list”, “properties”, “options-txt”



*Default:*
` null `



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
` "nogui" `



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

```
{
  _instanceType = "server";
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "1.21.10";
    priority = 1500;
  };
}
```



## server\.instances\.\<name>\.forgeLoader\.enable



Whether to enable forge loader\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## server\.instances\.\<name>\.forgeLoader\.hash



This option has no description\.



*Type:*
non-empty string



*Default:*
` "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=" `



## server\.instances\.\<name>\.forgeLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



## server\.instances\.\<name>\.forgeLoader\.parsedForgeLoader



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*
` "parsedForgeLoader" `



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



## server\.instances\.\<name>\.java\.cp



This option has no description\.



*Type:*
list of absolute path



*Default:*
` [ ] `



## server\.instances\.\<name>\.java\.extraArguments



This option has no description\.



*Type:*
list of non-empty string



*Default:*
` [ ] `



## server\.instances\.\<name>\.java\.finalArgumentShellString



This option has no description\.



*Type:*
non-empty string *(read only)*



*Default:*
` "" `



## server\.instances\.\<name>\.java\.finalArguments



This option has no description\.



*Type:*
list of string *(read only)*



*Default:*
` [ ] `



## server\.instances\.\<name>\.java\.jar



This option has no description\.



*Type:*
null or absolute path



*Default:*
` null `



## server\.instances\.\<name>\.java\.mainClass



This option has no description\.



*Type:*
null or non-empty string



*Default:*
` null `



## server\.instances\.\<name>\.java\.maxMemory



This option has no description\.



*Type:*
null or (Java memory size (in MBs))



*Default:*
` null `



## server\.instances\.\<name>\.java\.memory



This option has no description\.



*Type:*
null or (Java memory size (in MBs))



*Default:*
` null `



## server\.instances\.\<name>\.java\.minMemory



This option has no description\.



*Type:*
null or (Java memory size (in MBs))



*Default:*
` null `



## server\.instances\.\<name>\.lazymc



This option has no description\.



*Type:*
submodule



## server\.instances\.\<name>\.lazymc\.enable



Whether to enable lazymc\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## server\.instances\.\<name>\.lazymc\.package



This option has no description\.



*Type:*
package



*Default:*
` <derivation lazymc-0.2.11> `



## server\.instances\.\<name>\.lazymc\.settings



This option has no description\.



*Type:*
attribute set



*Default:*
` { } `



## server\.instances\.\<name>\.libraries



This option has no description\.



*Type:*
list of (attribute set)



*Default:*
` [ ] `



## server\.instances\.\<name>\.mainJar



This option has no description\.



*Type:*
absolute path



## server\.instances\.\<name>\.meta\.versionData



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*
` "versionData" `



## server\.instances\.\<name>\.mrpack



This option has no description\.



*Type:*
submodule



*Default:*

```
{
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "1.21.10";
    priority = 1500;
  };
}
```



## server\.instances\.\<name>\.mrpack\.enable



Whether to enable enable mrpack\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## server\.instances\.\<name>\.mrpack\.enableOptionalMods



Whether to enable optional mods\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `



## server\.instances\.\<name>\.mrpack\._parsedMrpack



This option has no description\.



*Type:*
attribute set



## server\.instances\.\<name>\.mrpack\.fabricLoaderVersion



This option has no description\.



*Type:*
null or non-empty string



## server\.instances\.\<name>\.mrpack\.file



This option has no description\.



*Type:*
package



## server\.instances\.\<name>\.mrpack\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



## server\.instances\.\<name>\.mrpack\.mutableOverrides



Whether to enable mutable overrides\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `



## server\.instances\.\<name>\.mrpack\.placeOverrides



Whether to enable placing overrides\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `



## server\.instances\.\<name>\.mrpack\.quiltLoaderVersion



This option has no description\.



*Type:*
null or non-empty string



## server\.instances\.\<name>\.noGui



Whether to enable no gui\.



*Type:*
boolean



*Default:*
` true `



*Example:*
` true `



## server\.instances\.\<name>\.paper



This option has no description\.



*Type:*
submodule



*Default:*

```
{
  enable = false;
}
```



## server\.instances\.\<name>\.paper\.enable



Whether to enable paper\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## server\.instances\.\<name>\.paper\._mainClass



This option has no description\.



*Type:*
non-empty string *(read only)*



*Default:*
` "<inferred>" `



## server\.instances\.\<name>\.paper\._serverJar



This option has no description\.



*Type:*
package *(read only)*



*Default:*
` "serverJar" `



## server\.instances\.\<name>\.paper\.buildNumber



This option has no description\.



*Type:*
non-empty string



*Default:*
` "<inferred>" `



## server\.instances\.\<name>\.paper\.meta

This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*
` "meta" `



## server\.instances\.\<name>\.paper\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



*Default:*
` "<inferred>" `



## server\.instances\.\<name>\.placeFilesAtActivation



Whether to enable placing files during activation\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## server\.instances\.\<name>\.preLaunchShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n”



*Default:*
` "" `



## server\.instances\.\<name>\.quiltLoader



This option has no description\.



*Type:*
submodule



*Default:*

```
{
  _instanceType = "server";
  enable = false;
  minecraftVersion = {
    _type = "override";
    content = "1.21.10";
    priority = 1500;
  };
}
```



## server\.instances\.\<name>\.quiltLoader\.enable



Whether to enable quilt loader\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## server\.instances\.\<name>\.quiltLoader\.classes



This option has no description\.



*Type:*
list of absolute path *(read only)*



## server\.instances\.\<name>\.quiltLoader\.hash



This option has no description\.



*Type:*
non-empty string



## server\.instances\.\<name>\.quiltLoader\.meta



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*
` "meta" `



## server\.instances\.\<name>\.quiltLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



## server\.instances\.\<name>\.quiltLoader\.version



This option has no description\.



*Type:*
non-empty string



## server\.instances\.\<name>\.runtimeLibs



Libraries available at runtime



*Type:*
list of absolute path



*Default:*
` [ ] `



## server\.instances\.\<name>\.runtimePrograms



This option has no description\.



*Type:*
list of absolute path



*Default:*
` [ ] `



## server\.instances\.\<name>\.serverProperties



This option has no description\.



*Type:*
null or (attribute set of (null or boolean or signed integer or string))



*Default:*
` null `



## server\.instances\.\<name>\.service



This option has no description\.



*Type:*
submodule



*Default:*

```
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
` false `



*Example:*
` true `



## server\.instances\.\<name>\.service\.autoStart



Whether to enable enables by default\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## server\.instances\.\<name>\.version



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



*Default:*
` "latest-release" `



## server\.instances\.\<name>\.world



Path to world dir\. Only placed if the directory doesn’t exist



*Type:*
null or absolute path



*Default:*
` null `



## server\.shared



This option has no description\.



*Type:*
attribute set



*Default:*
` { } `


