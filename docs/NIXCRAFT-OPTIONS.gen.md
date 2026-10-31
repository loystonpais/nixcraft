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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/nixcraft\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/nixcraft.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.module)



## activationShellScript

This option has no description\.



*Type:*
strings concatenated with “\\n”

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/nixcraft\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/nixcraft.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.module)



## client



This option has no description\.



*Type:*
submodule

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/nixcraft\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/nixcraft.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.module)



## client\.auth\.uuid



Default player UUID for client authentication\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.client\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.client.module)



## client\.dir



This option has no description\.



*Type:*
absolute path



*Default:*

```nix
"/(root)/.local/share/nixcraft/client/instances"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.client\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.client.module)



## client\.instances



This option has no description\.



*Type:*
attribute set of (submodule)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.client\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.client.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.enableExternalAssets



Whether to enable external asset management via fetchAssets script\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.enableMangoHud



Whether to enable mangohud\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\._classSettings



This option has no description\.



*Type:*
submodule

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\._classSettings\.assetIndex



This option has no description\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\._classSettings\.assetsDir



This option has no description\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\._classSettings\.fullscreen



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\._classSettings\.gameDir



This option has no description\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\._classSettings\.height



This option has no description\.



*Type:*
null or (positive integer, meaning >0)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\._classSettings\.userProperties



This option has no description\.



*Type:*
null or (attribute set)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\._classSettings\.username



This option has no description\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\._classSettings\.uuid



This option has no description\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\._classSettings\.version



This option has no description\.



*Type:*
non-empty string

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\._classSettings\.width



This option has no description\.



*Type:*
null or (positive integer, meaning >0)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.absoluteDir



This option has no description\.



*Type:*
absolute path



*Default:*

```nix
"/(root)/.local/share/nixcraft/client/instances/‹name›"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.account



This option has no description\.



*Type:*
null or (submodule)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.account\.authDir



Path to nixcraft auth cache directory\.



*Type:*
string



*Default:*

```nix
"/(root)/.local/share/nixcraft/client/auth"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.account\.offline



Whether this account is offline (unauthenticated)\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.account\.username



Player username\. For online accounts, used to verify against authenticated profile\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.account\.uuid



Player UUID\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.activationShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n”



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.binEntry



This option has no description\.



*Type:*
submodule

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.binEntry\.finalBin



This option has no description\.



*Type:*
package *(read only)*



*Default:*

```nix
<derivation nixcraft-client--name->
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.binEntry\.name



This option has no description\.



*Type:*
non-empty string

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.bwrap



This option has no description\.



*Type:*
submodule



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 1-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 1-entry 1]")



## client\.instances\.\<name>\.bwrap\.enable



Whether to enable bwrap\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 1-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 1-entry 1]")



## client\.instances\.\<name>\.bwrap\.package



This option has no description\.



*Type:*
package



*Default:*

```nix
<derivation nixcraft-bwrap>
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 1-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 1-entry 1]")



## client\.instances\.\<name>\.bwrap\.extraArguments



This option has no description\.



*Type:*
list of non-empty string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 1-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 1-entry 1]")



## client\.instances\.\<name>\.bwrap\.mountOpenglDriver



This option has no description\.



*Type:*
boolean



*Default:*

```nix
true
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 1-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 1-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.desktopEntry\.extraConfig



This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.desktopEntry\.name



This option has no description\.



*Type:*
non-empty string



*Default:*

```nix
"Nixcraft Instance ‹name›"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.externalAssetsDir



Path to external assets directory



*Type:*
null or absolute path



*Default:*

```nix
"/(root)/.local/share/nixcraft/client/assets"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.externalAssetsExtraLookupPaths



Extra paths to read/lookup cached assets from when fetching external assets\.



*Type:*
list of (string or absolute path)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.extraArguments



This option has no description\.



*Type:*
list of non-empty string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## client\.instances\.\<name>\.fabricLoader\.finalLibraries



This option has no description\.



*Type:*
attribute set of (submodule) *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## client\.instances\.\<name>\.fabricLoader\.finalLibraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## client\.instances\.\<name>\.fabricLoader\.finalLibraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## client\.instances\.\<name>\.fabricLoader\.finalLibraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## client\.instances\.\<name>\.fabricLoader\.finalLibraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## client\.instances\.\<name>\.fabricLoader\.hash



This option has no description\.



*Type:*
non-empty string



*Default:*

```nix
"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## client\.instances\.\<name>\.fabricLoader\.meta



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"meta"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## client\.instances\.\<name>\.fabricLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## client\.instances\.\<name>\.fabricLoader\.version



Fabric loader version, or ‘latest’



*Type:*
value “latest” (singular enum) or (Fabric loader version)



*Default:*

```nix
"latest"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## client\.instances\.\<name>\.files



This option has no description\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## client\.instances\.\<name>\.files\.\<name>\.dirName



This option has no description\.



*Type:*
unspecified value *(read only)*



*Default:*

```nix
"."
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## client\.instances\.\<name>\.files\.\<name>\.extraConfig



This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## client\.instances\.\<name>\.files\.\<name>\.fileName



This option has no description\.



*Type:*
unspecified value *(read only)*



*Default:*

```nix
"‹name›"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## client\.instances\.\<name>\.files\.\<name>\.finalSource



This option has no description\.



*Type:*
absolute path *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## client\.instances\.\<name>\.files\.\<name>\.force



Overwrite previously existing file/symlink/dir



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## client\.instances\.\<name>\.files\.\<name>\.method



Method to place the file in target location
copy-init     - copy once during init (suitable for config files from modpacks)
copy          - copy every rebuild
symlink       - symlink every rebuild
merge         - merge file at runtime
world         - recursive copy directory only if it doesn’t exist already (used internally for world/saves)



*Type:*
one of “copy”, “copy-init”, “symlink”, “world”, “merge”



*Default:*

```nix
"symlink"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## client\.instances\.\<name>\.files\.\<name>\.source



This option has no description\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## client\.instances\.\<name>\.files\.\<name>\.target



This option has no description\.



*Type:*
relative path *(read only)*



*Default:*

```nix
"‹name›"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## client\.instances\.\<name>\.files\.\<name>\.text



This option has no description\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## client\.instances\.\<name>\.files\.\<name>\.value



A value that will be transformed to the desired format when \.type is set



*Type:*
(list of anything) or attribute set of anything or anything

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## client\.instances\.\<name>\.finalActivationShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.finalArgumentShellString



This option has no description\.



*Type:*
non-empty string *(read only)*



*Default:*

```nix
"--version 26.3 --assetsDir /nix/store/bz28gjiyjnld8z3qyk7hy5k5ayms6l6h-minecraft-assets-dir --assetIndex 34 --gameDir '/(root)/.local/share/nixcraft/client/instances/‹name›'"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.finalFilePlacementShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## client\.instances\.\<name>\.finalLaunchShellCommandString



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.finalLaunchShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.finalLibraries



This option has no description\.



*Type:*
attribute set of (submodule) *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.finalLibraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.finalLibraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.finalLibraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.finalLibraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.finalPreLaunchShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.clientArguments



Loader specific game arguments for the client\.



*Type:*
list of string *(read only)*



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.finalInstallerLibraries



This option has no description\.



*Type:*
attribute set of (submodule) *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.finalInstallerLibraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.finalInstallerLibraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.finalInstallerLibraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.finalInstallerLibraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.finalLibraries



This option has no description\.



*Type:*
attribute set of (submodule) *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.finalLibraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.finalLibraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.finalLibraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.finalLibraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.installerJar



This option has no description\.



*Type:*
null or absolute path *(read only)*



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.meta\.isLegacy



This option has no description\.



*Type:*
boolean *(read only)*



*Default:*

```nix
(config.meta.loaders.installer or null) == null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.meta\.loaders



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
config.meta.sources.loaders.${config.version}
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.meta\.mainClass



This option has no description\.



*Type:*
null or non-empty string *(read only)*



*Default:*

```nix
if (config.meta.loaders.mainClass or null) != null
then config.meta.loaders.mainClass
else "io.github.zekerzhayard.forgewrapper.installer.Main"

```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.meta\.rawInstallerLibraries



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
config.meta.loaders.installerLibraries or {}
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.meta\.rawLibraries



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
config.meta.loaders.libraries
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.meta\.server\.installMarker



Path (relative to the instance dir) that exists once the server is installed\.



*Type:*
string *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.meta\.server\.javaArguments



Java arguments (relative to the instance dir) that launch the installed server\.



*Type:*
list of string *(read only)*



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.meta\.sources

This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"loaderSources"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.forgeLoader\.version



Forge loader version, or ‘latest’



*Type:*
value “latest” (singular enum) or (Forge loader version)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## client\.instances\.\<name>\.java



Java runtime and execution settings\.



*Type:*
submodule



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## client\.instances\.\<name>\.java\.package



Java runtime package to use\.



*Type:*
package

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## client\.instances\.\<name>\.java\.D



Java system properties (-D flags) to pass to the JVM\.



*Type:*
attribute set of (string or absolute path or package or signed integer or boolean or floating point number)



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## client\.instances\.\<name>\.java\.cp



Java classpath (-cp) entries\.



*Type:*
list of absolute path



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## client\.instances\.\<name>\.java\.extraArguments



Extra JVM arguments\.



*Type:*
list of non-empty string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## client\.instances\.\<name>\.java\.finalArgumentShellString



Shell-escaped string of finalArguments\.



*Type:*
string *(read only)*



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## client\.instances\.\<name>\.java\.finalArguments



Complete list of JVM arguments constructed from all Java options\.



*Type:*
list of string *(read only)*



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## client\.instances\.\<name>\.java\.jar



Main jar file to run with -jar\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## client\.instances\.\<name>\.java\.mainClass



Main class to execute\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## client\.instances\.\<name>\.java\.maxMemory



Maximum memory limit (in MB) for the JVM (-Xmx)\.



*Type:*
null or (Java memory size (in MBs))



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## client\.instances\.\<name>\.java\.memory



Sets both minMemory and maxMemory to the same value\.



*Type:*
null or (Java memory size (in MBs))



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## client\.instances\.\<name>\.java\.minMemory



Initial memory allocation (in MB) for the JVM (-Xms)\.



*Type:*
null or (Java memory size (in MBs))



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.launchPrefix



This option has no description\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.launchPrefix\.\<name>\.enable



Whether to enable launch prefix entry\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.launchPrefix\.\<name>\.command



This option has no description\.



*Type:*
list of (string or absolute path or package)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.launchPrefix\.\<name>\.envVars



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.launchPrefix\.\<name>\.name



This option has no description\.



*Type:*
string *(read only)*



*Default:*

```nix
"‹name›"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.launchPrefix\.\<name>\.priority



This option has no description\.



*Type:*
signed integer



*Default:*

```nix
1000
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.launchPrefix\.\<name>\.separator



This option has no description\.



*Type:*
null or string



*Default:*

```nix
"--"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.libraries



This option has no description\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.libraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.libraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.libraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.libraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.lwjgl\.version



This option has no description\.



*Type:*
null or value “latest” (singular enum) or (LWJGL version)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.mainJar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.mcsr\.enable



Whether to enable MCSR\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mcsr\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.extensions\."\[definition 1-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mcsr.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.extensions."[definition 1-entry 1]")



## client\.instances\.\<name>\.meta\.versionData



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"sources.mojang.versions.\${config.version}"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.mods



This option has no description\.



*Type:*
list of (absolute path or package)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



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
    content = "26.3";
    priority = 1500;
  };
}
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## client\.instances\.\<name>\.mrpack\._parsedMrpack



This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## client\.instances\.\<name>\.mrpack\.fabricLoaderVersion



This option has no description\.



*Type:*
null or (Fabric loader version)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## client\.instances\.\<name>\.mrpack\.file



This option has no description\.



*Type:*
package

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## client\.instances\.\<name>\.mrpack\.forgeLoaderVersion



This option has no description\.



*Type:*
null or (Forge loader version)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## client\.instances\.\<name>\.mrpack\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## client\.instances\.\<name>\.mrpack\.neoforgeLoaderVersion



This option has no description\.



*Type:*
null or (NeoForge loader version)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## client\.instances\.\<name>\.mrpack\.quiltLoaderVersion



This option has no description\.



*Type:*
null or (Quilt loader version)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## client\.instances\.\<name>\.mutableLibrariesDir



Whether to enable placing libraries in the instance’s mutable libraries directory
and using those paths on the classpath
\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.neoForgeLoader\.enable



Whether to enable NeoForge loader\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.clientArguments



Loader specific game arguments for the client\.



*Type:*
list of string *(read only)*



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.finalInstallerLibraries



This option has no description\.



*Type:*
attribute set of (submodule) *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.finalInstallerLibraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.finalInstallerLibraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.finalInstallerLibraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.finalInstallerLibraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.finalLibraries



This option has no description\.



*Type:*
attribute set of (submodule) *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.finalLibraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.finalLibraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.finalLibraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.finalLibraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.installerJar



This option has no description\.



*Type:*
null or absolute path *(read only)*



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.meta\.isLegacy



This option has no description\.



*Type:*
boolean *(read only)*



*Default:*

```nix
(config.meta.loaders.installer or null) == null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.meta\.loaders



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
config.meta.sources.loaders.${config.version}
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.meta\.mainClass



This option has no description\.



*Type:*
null or non-empty string *(read only)*



*Default:*

```nix
if (config.meta.loaders.mainClass or null) != null
then config.meta.loaders.mainClass
else "io.github.zekerzhayard.forgewrapper.installer.Main"

```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.meta\.rawInstallerLibraries



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
config.meta.loaders.installerLibraries or {}
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.meta\.rawLibraries



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
config.meta.loaders.libraries
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.meta\.server\.installMarker



Path (relative to the instance dir) that exists once the server is installed\.



*Type:*
string *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.meta\.server\.javaArguments



Java arguments (relative to the instance dir) that launch the installed server\.



*Type:*
list of string *(read only)*



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.meta\.sources



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"loaderSources"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.neoForgeLoader\.version



NeoForge loader version, or ‘latest’



*Type:*
value “latest” (singular enum) or (NeoForge loader version)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## client\.instances\.\<name>\.optionsTxt



This option has no description\.



*Type:*
null or (attribute set of anything)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## client\.instances\.\<name>\.preLaunchShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n”



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## client\.instances\.\<name>\.quiltLoader\.finalLibraries



This option has no description\.



*Type:*
attribute set of (submodule) *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## client\.instances\.\<name>\.quiltLoader\.finalLibraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## client\.instances\.\<name>\.quiltLoader\.finalLibraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## client\.instances\.\<name>\.quiltLoader\.finalLibraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## client\.instances\.\<name>\.quiltLoader\.finalLibraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## client\.instances\.\<name>\.quiltLoader\.hash



This option has no description\.



*Type:*
non-empty string



*Default:*

```nix
"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## client\.instances\.\<name>\.quiltLoader\.meta



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"meta"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## client\.instances\.\<name>\.quiltLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## client\.instances\.\<name>\.quiltLoader\.version



Quilt loader version, or ‘latest’



*Type:*
value “latest” (singular enum) or (Quilt loader version)



*Default:*

```nix
"latest"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.renice\.priority



Niceness priority value (between -20 and 19)\. Lower values mean higher priority\.



*Type:*
signed integer



*Default:*

```nix
-20
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.renice\.wrappedBinPath



This option has no description\.



*Type:*
absolute path



*Default:*

```nix
"/run/wrappers/bin/nixcraft-renice"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.runtimeLibs



Libraries available at runtime



*Type:*
list of absolute path



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.runtimePrograms



This option has no description\.



*Type:*
list of absolute path



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.skinsDir



Path to writable directory where client skins are cached/stored\.



*Type:*
null or absolute path



*Default:*

```nix
"/(root)/.local/share/nixcraft/client/skins"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.module)



## client\.instances\.\<name>\.version



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



*Default:*

```nix
"latest-release"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## client\.instances\.\<name>\.waywall



This option has no description\.



*Type:*
submodule

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.extensions."[definition 2-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.extensions."[definition 2-entry 1]")



## client\.instances\.\<name>\.waywall\.package



This option has no description\.



*Type:*
package

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.extensions."[definition 2-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.extensions."[definition 2-entry 1]")



## client\.instances\.\<name>\.waywall\.configText



Lua script passed as init\.lua



*Type:*
null or non-empty string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.extensions."[definition 2-entry 1]")



## client\.instances\.\<name>\.waywall\.extraArguments



This option has no description\.



*Type:*
list of non-empty string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.extensions."[definition 2-entry 1]")



## client\.instances\.\<name>\.waywall\.noEnvReexec



This option has no description\.



*Type:*
boolean



*Default:*

```nix
true
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.extensions."[definition 2-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.clientInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/waywall.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.clientInstance.extensions."[definition 2-entry 1]")



## client\.shared



This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.client\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/client.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.client.module)



## finalActivationShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*



*Default:*

```nix
''
  # Nixcraft activation script
  
  
''
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/nixcraft\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/nixcraft.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.module)



## server



This option has no description\.



*Type:*
submodule

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/nixcraft\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/nixcraft.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.module)



## server\.dir



This option has no description\.



*Type:*
absolute path



*Default:*

```nix
"/(root)/.local/share/nixcraft/server/instances"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.server\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.server.module)



## server\.instances



This option has no description\.



*Type:*
attribute set of (submodule)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.server\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.server.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.module)



## server\.instances\.\<name>\.absoluteDir



This option has no description\.



*Type:*
absolute path



*Default:*

```nix
"/(root)/.local/share/nixcraft/server/instances/‹name›"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.activationShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n”



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.module)



## server\.instances\.\<name>\.binEntry



This option has no description\.



*Type:*
submodule

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.binEntry\.finalBin



This option has no description\.



*Type:*
package *(read only)*



*Default:*

```nix
<derivation nixcraft-server--name->
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.binEntry\.name



This option has no description\.



*Type:*
non-empty string

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.bwrap



This option has no description\.



*Type:*
submodule



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 1-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 1-entry 1]")



## server\.instances\.\<name>\.bwrap\.enable



Whether to enable bwrap\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 1-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 1-entry 1]")



## server\.instances\.\<name>\.bwrap\.package



This option has no description\.



*Type:*
package



*Default:*

```nix
<derivation nixcraft-bwrap>
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 1-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 1-entry 1]")



## server\.instances\.\<name>\.bwrap\.extraArguments



This option has no description\.



*Type:*
list of non-empty string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 1-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 1-entry 1]")



## server\.instances\.\<name>\.bwrap\.mountOpenglDriver



This option has no description\.



*Type:*
boolean



*Default:*

```nix
true
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 1-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/bwrap.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 1-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.extraArguments



This option has no description\.



*Type:*
list of non-empty string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## server\.instances\.\<name>\.fabricLoader\.finalLibraries



This option has no description\.



*Type:*
attribute set of (submodule) *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## server\.instances\.\<name>\.fabricLoader\.finalLibraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## server\.instances\.\<name>\.fabricLoader\.finalLibraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## server\.instances\.\<name>\.fabricLoader\.finalLibraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## server\.instances\.\<name>\.fabricLoader\.finalLibraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## server\.instances\.\<name>\.fabricLoader\.hash



This option has no description\.



*Type:*
non-empty string



*Default:*

```nix
"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## server\.instances\.\<name>\.fabricLoader\.meta



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"meta"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## server\.instances\.\<name>\.fabricLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## server\.instances\.\<name>\.fabricLoader\.version



Fabric loader version, or ‘latest’



*Type:*
value “latest” (singular enum) or (Fabric loader version)



*Default:*

```nix
"latest"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/fabric.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 2-entry 1]")



## server\.instances\.\<name>\.files



This option has no description\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.files\.\<name>\.dirName



This option has no description\.



*Type:*
unspecified value *(read only)*



*Default:*

```nix
"."
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.files\.\<name>\.extraConfig



This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.files\.\<name>\.fileName



This option has no description\.



*Type:*
unspecified value *(read only)*



*Default:*

```nix
"‹name›"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.files\.\<name>\.finalSource



This option has no description\.



*Type:*
absolute path *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.files\.\<name>\.force



Overwrite previously existing file/symlink/dir



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.files\.\<name>\.method



Method to place the file in target location
copy-init     - copy once during init (suitable for config files from modpacks)
copy          - copy every rebuild
symlink       - symlink every rebuild
merge         - merge file at runtime
world         - recursive copy directory only if it doesn’t exist already (used internally for world/saves)



*Type:*
one of “copy”, “copy-init”, “symlink”, “world”, “merge”



*Default:*

```nix
"symlink"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.files\.\<name>\.source



This option has no description\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.files\.\<name>\.target



This option has no description\.



*Type:*
relative path *(read only)*



*Default:*

```nix
"‹name›"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.files\.\<name>\.text



This option has no description\.



*Type:*
null or string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.files\.\<name>\.value



A value that will be transformed to the desired format when \.type is set



*Type:*
(list of anything) or attribute set of anything or anything

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.finalActivationShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.finalArgumentShellString



This option has no description\.



*Type:*
string *(read only)*



*Default:*

```nix
"nogui"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.module)



## server\.instances\.\<name>\.finalFilePlacementShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.finalLaunchShellCommandString



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.finalLaunchShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.finalLibraries



This option has no description\.



*Type:*
attribute set of (submodule) *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.finalLibraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.finalLibraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.finalLibraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.finalLibraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.finalPreLaunchShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n” *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.clientArguments



Loader specific game arguments for the client\.



*Type:*
list of string *(read only)*



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.finalInstallerLibraries



This option has no description\.



*Type:*
attribute set of (submodule) *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.finalInstallerLibraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.finalInstallerLibraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.finalInstallerLibraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.finalInstallerLibraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.finalLibraries



This option has no description\.



*Type:*
attribute set of (submodule) *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.finalLibraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.finalLibraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.finalLibraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.finalLibraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.installerJar



This option has no description\.



*Type:*
null or absolute path *(read only)*



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.meta\.isLegacy



This option has no description\.



*Type:*
boolean *(read only)*



*Default:*

```nix
(config.meta.loaders.installer or null) == null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.meta\.loaders



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
config.meta.sources.loaders.${config.version}
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.meta\.mainClass



This option has no description\.



*Type:*
null or non-empty string *(read only)*



*Default:*

```nix
if (config.meta.loaders.mainClass or null) != null
then config.meta.loaders.mainClass
else "io.github.zekerzhayard.forgewrapper.installer.Main"

```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.meta\.rawInstallerLibraries



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
config.meta.loaders.installerLibraries or {}
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.meta\.rawLibraries



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
config.meta.loaders.libraries
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.meta\.server\.installMarker



Path (relative to the instance dir) that exists once the server is installed\.



*Type:*
string *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.meta\.server\.javaArguments



Java arguments (relative to the instance dir) that launch the installed server\.



*Type:*
list of string *(read only)*



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.meta\.sources



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"loaderSources"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.forgeLoader\.version



Forge loader version, or ‘latest’



*Type:*
value “latest” (singular enum) or (Forge loader version)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 4-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/forge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 4-entry 1]")



## server\.instances\.\<name>\.java



Java runtime and execution settings\.



*Type:*
submodule



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## server\.instances\.\<name>\.java\.package



Java runtime package to use\.



*Type:*
package

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## server\.instances\.\<name>\.java\.D



Java system properties (-D flags) to pass to the JVM\.



*Type:*
attribute set of (string or absolute path or package or signed integer or boolean or floating point number)



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## server\.instances\.\<name>\.java\.cp



Java classpath (-cp) entries\.



*Type:*
list of absolute path



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## server\.instances\.\<name>\.java\.extraArguments



Extra JVM arguments\.



*Type:*
list of non-empty string



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## server\.instances\.\<name>\.java\.finalArgumentShellString



Shell-escaped string of finalArguments\.



*Type:*
string *(read only)*



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## server\.instances\.\<name>\.java\.finalArguments



Complete list of JVM arguments constructed from all Java options\.



*Type:*
list of string *(read only)*



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## server\.instances\.\<name>\.java\.jar



Main jar file to run with -jar\.



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## server\.instances\.\<name>\.java\.mainClass



Main class to execute\.



*Type:*
null or non-empty string



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## server\.instances\.\<name>\.java\.maxMemory



Maximum memory limit (in MB) for the JVM (-Xmx)\.



*Type:*
null or (Java memory size (in MBs))



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## server\.instances\.\<name>\.java\.memory



Sets both minMemory and maxMemory to the same value\.



*Type:*
null or (Java memory size (in MBs))



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



## server\.instances\.\<name>\.java\.minMemory



Initial memory allocation (in MB) for the JVM (-Xms)\.



*Type:*
null or (Java memory size (in MBs))



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 5-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/java.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 5-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.launchPrefix



This option has no description\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.launchPrefix\.\<name>\.enable



Whether to enable launch prefix entry\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.launchPrefix\.\<name>\.command



This option has no description\.



*Type:*
list of (string or absolute path or package)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.launchPrefix\.\<name>\.envVars



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.launchPrefix\.\<name>\.name



This option has no description\.



*Type:*
string *(read only)*



*Default:*

```nix
"‹name›"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.launchPrefix\.\<name>\.priority



This option has no description\.



*Type:*
signed integer



*Default:*

```nix
1000
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.launchPrefix\.\<name>\.separator



This option has no description\.



*Type:*
null or string



*Default:*

```nix
"--"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.lazymc



This option has no description\.



*Type:*
submodule

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/lazymc\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.extensions\."\[definition 1-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/lazymc.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.extensions."[definition 1-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/lazymc\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.extensions\."\[definition 1-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/lazymc.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.extensions."[definition 1-entry 1]")



## server\.instances\.\<name>\.lazymc\.package



This option has no description\.



*Type:*
package



*Default:*

```nix
<derivation lazymc-0.2.11>
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/lazymc\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.extensions\."\[definition 1-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/lazymc.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.extensions."[definition 1-entry 1]")



## server\.instances\.\<name>\.lazymc\.settings

This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/lazymc\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.extensions\."\[definition 1-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/lazymc.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.extensions."[definition 1-entry 1]")



## server\.instances\.\<name>\.libraries



This option has no description\.



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.libraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.libraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.libraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.libraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.mainJar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.meta\.versionData



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"sources.mojang.versions.\${config.version}"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.mods



This option has no description\.



*Type:*
list of (absolute path or package)



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



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
    content = "26.3";
    priority = 1500;
  };
}
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## server\.instances\.\<name>\.mrpack\._parsedMrpack



This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## server\.instances\.\<name>\.mrpack\.fabricLoaderVersion



This option has no description\.



*Type:*
null or (Fabric loader version)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## server\.instances\.\<name>\.mrpack\.file



This option has no description\.



*Type:*
package

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## server\.instances\.\<name>\.mrpack\.forgeLoaderVersion



This option has no description\.



*Type:*
null or (Forge loader version)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## server\.instances\.\<name>\.mrpack\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## server\.instances\.\<name>\.mrpack\.neoforgeLoaderVersion



This option has no description\.



*Type:*
null or (NeoForge loader version)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## server\.instances\.\<name>\.mrpack\.quiltLoaderVersion



This option has no description\.



*Type:*
null or (Quilt loader version)



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 6-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/mrpack.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 6-entry 1]")



## server\.instances\.\<name>\.mutableLibrariesDir



Whether to enable placing libraries in the instance’s mutable libraries directory
and using those paths on the classpath
\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.neoForgeLoader\.enable



Whether to enable NeoForge loader\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.clientArguments



Loader specific game arguments for the client\.



*Type:*
list of string *(read only)*



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.finalInstallerLibraries



This option has no description\.



*Type:*
attribute set of (submodule) *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.finalInstallerLibraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.finalInstallerLibraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.finalInstallerLibraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.finalInstallerLibraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.finalLibraries



This option has no description\.



*Type:*
attribute set of (submodule) *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.finalLibraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.finalLibraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.finalLibraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.finalLibraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.installerJar



This option has no description\.



*Type:*
null or absolute path *(read only)*



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.meta\.isLegacy



This option has no description\.



*Type:*
boolean *(read only)*



*Default:*

```nix
(config.meta.loaders.installer or null) == null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.meta\.loaders



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
config.meta.sources.loaders.${config.version}
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.meta\.mainClass



This option has no description\.



*Type:*
null or non-empty string *(read only)*



*Default:*

```nix
if (config.meta.loaders.mainClass or null) != null
then config.meta.loaders.mainClass
else "io.github.zekerzhayard.forgewrapper.installer.Main"

```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.meta\.rawInstallerLibraries



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
config.meta.loaders.installerLibraries or {}
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.meta\.rawLibraries



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
config.meta.loaders.libraries
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.meta\.server\.installMarker



Path (relative to the instance dir) that exists once the server is installed\.



*Type:*
string *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.meta\.server\.javaArguments



Java arguments (relative to the instance dir) that launch the installed server\.



*Type:*
list of string *(read only)*



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.meta\.sources



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"loaderSources"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



## server\.instances\.\<name>\.neoForgeLoader\.version



NeoForge loader version, or ‘latest’



*Type:*
value “latest” (singular enum) or (NeoForge loader version)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 7-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/neoforge.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 7-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/paper\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/paper.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.extensions."[definition 2-entry 1]")



## server\.instances\.\<name>\.paper\._mainClass



This option has no description\.



*Type:*
non-empty string *(read only)*



*Default:*

```nix
"<inferred>"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/paper\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/paper.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.extensions."[definition 2-entry 1]")



## server\.instances\.\<name>\.paper\._serverJar



This option has no description\.



*Type:*
package *(read only)*



*Default:*

```nix
"serverJar"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/paper\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/paper.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.extensions."[definition 2-entry 1]")



## server\.instances\.\<name>\.paper\.buildNumber



This option has no description\.



*Type:*
signed integer or non-empty string



*Default:*

```nix
"<inferred>"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/paper\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/paper.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.extensions."[definition 2-entry 1]")



## server\.instances\.\<name>\.paper\.meta



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"meta"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/paper\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/paper.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.extensions."[definition 2-entry 1]")



## server\.instances\.\<name>\.paper\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



*Default:*

```nix
"<inferred>"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/paper\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.extensions\."\[definition 2-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/paper.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.extensions."[definition 2-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/file.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.preLaunchShellScript



This option has no description\.



*Type:*
strings concatenated with “\\n”



*Default:*

```nix
""
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.purpur\.enable



Whether to enable Purpur\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/purpur\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/purpur.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.purpur\._serverJar



This option has no description\.



*Type:*
package *(read only)*



*Default:*

```nix
"serverJar"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/purpur\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/purpur.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.purpur\.meta



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"meta"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/purpur\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/purpur.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.extensions."[definition 3-entry 1]")



## server\.instances\.\<name>\.purpur\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



*Default:*

```nix
"<inferred>"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/purpur\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.extensions\."\[definition 3-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/purpur.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.extensions."[definition 3-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## server\.instances\.\<name>\.quiltLoader\.finalLibraries



This option has no description\.



*Type:*
attribute set of (submodule) *(read only)*

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## server\.instances\.\<name>\.quiltLoader\.finalLibraries\.\<name>\.enable



Whether to enable library ‹name›\.



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## server\.instances\.\<name>\.quiltLoader\.finalLibraries\.\<name>\.jar



This option has no description\.



*Type:*
absolute path

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## server\.instances\.\<name>\.quiltLoader\.finalLibraries\.\<name>\.native



This option has no description\.



*Type:*
boolean



*Default:*

```nix
false
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## server\.instances\.\<name>\.quiltLoader\.finalLibraries\.\<name>\.relativePath



This option has no description\.



*Type:*
null or relative path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## server\.instances\.\<name>\.quiltLoader\.hash



This option has no description\.



*Type:*
non-empty string



*Default:*

```nix
"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## server\.instances\.\<name>\.quiltLoader\.meta



This option has no description\.



*Type:*
attribute set *(read only)*



*Default:*

```nix
"meta"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## server\.instances\.\<name>\.quiltLoader\.minecraftVersion



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



## server\.instances\.\<name>\.quiltLoader\.version



Quilt loader version, or ‘latest’



*Type:*
value “latest” (singular enum) or (Quilt loader version)



*Default:*

```nix
"latest"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.extensions\."\[definition 8-entry 1]"](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/extensions/quilt.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.extensions."[definition 8-entry 1]")



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.renice\.priority



Niceness priority value (between -20 and 19)\. Lower values mean higher priority\.



*Type:*
signed integer



*Default:*

```nix
-20
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.renice\.wrappedBinPath



This option has no description\.



*Type:*
absolute path



*Default:*

```nix
"/run/wrappers/bin/nixcraft-renice"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.runtimeLibs



Libraries available at runtime



*Type:*
list of absolute path



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.runtimePrograms



This option has no description\.



*Type:*
list of absolute path



*Default:*

```nix
[ ]
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.serverProperties



This option has no description\.



*Type:*
null or (attribute set of (null or boolean or signed integer or string))



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.module)



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

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.module)



## server\.instances\.\<name>\.version



Minecraft version, or one of: latest-release, latest-snapshot



*Type:*
one of “latest-release”, “latest-snapshot” or (Minecraft version)



*Default:*

```nix
"latest-release"
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.genericInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/generic-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.genericInstance.module)



## server\.instances\.\<name>\.world



Path to world dir\. Only placed if the directory doesn’t exist



*Type:*
null or absolute path



*Default:*

```nix
null
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.serverInstance\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server-instance.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.serverInstance.module)



## server\.shared



This option has no description\.



*Type:*
attribute set



*Default:*

```nix
{ }
```

*Declared by:*
 - [/nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server\.nix, via option perSystem, via option perSystem\.x86_64-linux\.nixcraft\.server\.module](file:///nix/store/kzn51gypd542v0xw85fjxkbdjfsq6vna-source/modules/server.nix, via option perSystem, via option perSystem.x86_64-linux.nixcraft.server.module)


