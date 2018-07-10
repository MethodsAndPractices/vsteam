---
external help file: VSTeam-Help.xml
Module Name: VSTeam
online version:
schema: 2.0.0
---

# Update-VSTeamBuild

## SYNOPSIS

Allows you to set the keep forever flag and build number.

## SYNTAX

## DESCRIPTION

Allows you to set the keep forever flag and build number.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuild | Update-VSTeamBuild -KeepForever $false
```

Sets the keep forever property of every build to false.

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Required: true
Position: 0
Accept pipeline input: true (ByPropertyName)
```

### -BuildNumber

The value you want to set as the build number.

```yaml
Type: String
Accept pipeline input: true (ByPropertyName, ByValue)
```

### -Id

The id of the build.

```yaml
Type: Int32
Aliases: BuildID
Accept pipeline input: true (ByPropertyName, ByValue)
```

### -KeepForever

$True or $False to set the keep forever property of the build.

```yaml
Type: Boolean
Accept pipeline input: true (ByPropertyName, ByValue)
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Aliases: cf
```

### -Force

Forces the command without confirmation

```yaml
Type: SwitchParameter
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Aliases: wi
```

## INPUTS

## OUTPUTS

### Team.Build

## NOTES

## RELATED LINKS