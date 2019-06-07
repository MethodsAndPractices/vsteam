


# Get-VSTeamReleaseDefinition

## SYNOPSIS

Gets the release definitions for a team project.

## SYNTAX

## DESCRIPTION

The Get-VSTeamReleaseDefinition function gets the release definitions for a team project.

The project name is a Dynamic Parameter which may not be displayed in the syntax above but is mandatory.

With just a project name, this function gets all of the release definitions for that team project.

You can also specify a particular release definition by ID.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamReleaseDefinition -ProjectName demo | Format-List *
```

This command gets a list of all release definitions in the demo project.

The pipeline operator (|) passes the data to the Format-List cmdlet, which displays all available properties (*) of the release definition objects.

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

### -Expand

Specifies which property should be expanded in the list of Release Definition (environments, artifacts, none).

```yaml
Type: String
Parameter Sets: List
```

### -Id

Specifies one or more release definitions by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release definition, type Get-VSTeamReleaseDefinition.

```yaml
Type: Int32[]
Parameter Sets: ByID
Aliases: ReleaseDefinitionID
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

### Int[]

## OUTPUTS

### Team.ReleaseDefinition

## NOTES

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamReleaseDefinition](Add-VSTeamReleaseDefinition.md)

[Remove-VSTeamReleaseDefinition](Remove-VSTeamReleaseDefinition.md)

