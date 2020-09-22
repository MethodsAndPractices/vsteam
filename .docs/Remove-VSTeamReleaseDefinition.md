<!-- #include "./common/header.md" -->

# Remove-VSTeamReleaseDefinition

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamReleaseDefinition.md" -->

## SYNTAX

## DESCRIPTION

The Remove-VSTeamReleaseDefinition function removes the release definitions for a team project.

The project name is a Dynamic Parameter which may not be displayed in the syntax above but is mandatory.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamReleaseDefinition -ProjectName demo | Remove-VSTeamReleaseDefinition
```

This command gets a list of all release definitions in the demo project.

The pipeline operator (|) passes the data to the Remove-VSTeamReleaseDefinition function, which removes each release definition object.

## PARAMETERS

### Id

Specifies one or more release definitions by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release definition, type Get-VSTeamReleaseDefinition.

```yaml
Type: Int32[]
Required: True
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

### None

## NOTES

You can pipe release definition IDs to this function.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamReleaseDefinition](Add-VSTeamReleaseDefinition.md)

[Get-VSTeamReleaseDefinition](Get-VSTeamReleaseDefinition.md)
