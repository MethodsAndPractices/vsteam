---
external help file: VSTeam-Help.xml
Module Name: VSTeam
online version:
schema: 2.0.0
---

# Remove-VSTeamProfile

## SYNOPSIS

Removes the profile.

## SYNTAX

## DESCRIPTION

Removes the profile.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamProfile | Remove-VSTeamProfile -Force
```

This will remove all the profiles on your system.

## PARAMETERS

### -Name

Name of profile to remove.

```yaml
Type: String
Required: True
```

### -Force

Forces the command without confirmation

```yaml
Type: SwitchParameter
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamProfile](Add-VSTeamProfile.md)