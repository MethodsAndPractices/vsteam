


# Show-VSTeamReleaseDefinition

## SYNOPSIS

Opens the release definitions for a team project in the default browser.

## SYNTAX

## DESCRIPTION

Opens the release definitions for a team project in the default browser.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Show-VSTeamReleaseDefinition -ProjectName Demo
```

This command will open a web browser with All Release Definitions for this project showing.

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 0
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -Id

Specifies release definition by ID.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases: ReleaseDefinitionID
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

### Team.ReleaseDefinition

## NOTES

You can pipe the release definition ID to this function.

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamReleaseDefinition](Add-VSTeamReleaseDefinition.md)

[Remove-VSTeamReleaseDefinition](Remove-VSTeamReleaseDefinition.md)

