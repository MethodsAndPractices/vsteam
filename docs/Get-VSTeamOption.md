---
external help file: VSTeam-Help.xml
Module Name: VSTeam
online version:
schema: 2.0.0
---

# Get-VSTeamOption

## SYNOPSIS

Returns all the versions of supported APIs of your TFS or VSTS.

## SYNTAX

## DESCRIPTION

Returns all the versions of supported APIs of your TFS or VSTS.

There are two table formats defined for the Team.Option type, Default and Versions.

Default view contains Name, Area, Max Version and URI Template.

Version view contains Name, Area, Min Version, Max Version, Released Version and Resource Version.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamOption
```

This will display all the versions of supported APIs for your account using the 'Default' table format.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamOption | Format-Table -View Versions
```

This will display all the versions of supported APIs for your account using the 'Versions' custom table format.

## PARAMETERS

### -Release

Returns options for Release Management APIs

```yaml
Type: SwitchParameter
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)