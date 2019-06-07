<!-- #include "./common/header.md" -->

# Remove-VSTeamReleaseDefinition

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamReleaseDefinition.md" -->

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

The pipeline operator (|) passes the data to the Remove-VSTeamReleaseDefinition function, which removes each release definition object.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Id

Specifies one or more release definitions by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release definition, type Get-VSTeamReleaseDefinition.

```yaml
Type: Int32[]
Required: True
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/force.md" -->

## INPUTS

## OUTPUTS

### None

## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the project for which this function gets release definitions.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have to pass the ProjectName with each call.

You can pipe release definition IDs to this function.

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamReleaseDefinition](Add-VSTeamReleaseDefinition.md)

[Get-VSTeamReleaseDefinition](Get-VSTeamReleaseDefinition.md)
