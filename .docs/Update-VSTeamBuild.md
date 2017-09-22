#include "./common/header.md"

# Update-VSTeamBuild

## SYNOPSIS
#include "./synopsis/Update-VSTeamBuild.md"

## SYNTAX

```
Update-VSTeamBuild [-Id] <Int32> [[-KeepForever] <Boolean>] [[-BuildNumber] <String>] [-Force] [-WhatIf] [-Confirm]
 [-ProjectName] <String>
```

## DESCRIPTION
Allows you to set the keep forever flag and build number.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-VSTeamBuild | Update-VSTeamBuild -KeepForever $false
```

Sets the keep forever property of every build to false.

## PARAMETERS

### -BuildNumber
The value you want to set as the build number.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

#include "./params/confirm.md"

#include "./params/force.md"

#include "./params/BuildId.md"

### -KeepForever
$True or $False to set the keep forever property of the build.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

#include "./params/projectName.md"

#include "./params/whatIf.md"

## INPUTS

### System.Int32
System.Boolean
System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS