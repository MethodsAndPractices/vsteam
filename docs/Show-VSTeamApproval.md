


# Show-VSTeamApproval

## SYNOPSIS

Opens the release associated with the waiting approval in the default browser.

## SYNTAX

## DESCRIPTION

Opens the release associated with the waiting approval in the default browser.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamApproval -ProjectName Demo | Show-VSTeamApproval
```

This command opens a web browser showing the release requiring approval.

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

### -ReleaseDefinitionId

Only approvals for the release id provided will be returned.

```yaml
Type: Int32
Aliases: Id
Required: True
Position: 1
Accept pipeline input: true (ByPropertyName, ByValue)
```

## INPUTS

## OUTPUTS

### Team.BuildDefinition

## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the project for which this function gets build definitions.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have to pass the ProjectName with each call.

You can pipe build definition IDs to this function.

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamBuildDefinition](Add-VSTeamBuildDefinition.md)

[Remove-VSTeamBuildDefinition](Remove-VSTeamBuildDefinition.md)

