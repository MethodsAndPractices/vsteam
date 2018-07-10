---
external help file: VSTeam-Help.xml
Module Name: VSTeam
online version:
schema: 2.0.0
---

# Set-VSTeamAPIVersion

## SYNOPSIS

Sets the API versions to support either TFS2017, TFS2018 or VSTS.

## SYNTAX

## DESCRIPTION

Set-VSTeamAPIVersion sets the versions of APIs used.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Set-VSTeamAPIVersion VSTS
```

This command sets the API versions to support VSTS.

## PARAMETERS

### -Version

Specifies the version to use. The acceptable values for this parameter are:

- TFS2017
- TFS2018
- VSTS

```yaml
Type: String
Required: True
Default value: TFS2017
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