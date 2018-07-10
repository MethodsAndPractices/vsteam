---
external help file: VSTeam-Help.xml
Module Name: VSTeam
online version:
schema: 2.0.0
---

# Remove-VSTeamReleaseDefinition

## SYNOPSIS

Removes the release definitions for a team project.

## SYNTAX

## DESCRIPTION

The Remove-VSTeamReleaseDefinition function removes the release definitions for a team project.

The project name is a Dynamic Parameter which may not be displayed in the syntax above but is mandatory.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamReleaseDefinition -ProjectName demo | Remove-VSTeamReleaseDefinition
```

This command gets a list of all release definitions in the demo project.

The pipeline operator (|) passes the data to the Remove-VSTeamReleaseDefinition function, which removes each release defintion object.

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

### -Id

Specifies one or more release definitions by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release defintion, type Get-VSTeamReleaseDefinition.

```yaml
Type: Int32[]
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -Force

Forces the command without confirmation

```yaml
Type: SwitchParameter
```

## INPUTS

## OUTPUTS

### None

## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the project for which this function gets release definitions.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have to pass the ProjectName with each call.

You can pipe release defintion IDs to this function.

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamReleaseDefinition](Add-VSTeamReleaseDefinition.md)

[Get-VSTeamReleaseDefinition](Get-VSTeamReleaseDefinition.md)