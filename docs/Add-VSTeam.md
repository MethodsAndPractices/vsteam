


# Add-VSTeam

## SYNOPSIS

Adds a team to a team project.

## SYNTAX

## DESCRIPTION

Adds a team to a team project.

## EXAMPLES

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

### -Description

The description of the team.

```yaml
Type: String
Position: 1
```

### -Name

The name of the team

```yaml
Type: String
Aliases: TeamName
Required: True
Position: 1
```

## INPUTS

## OUTPUTS

## NOTES

Prerequisites: 

Once per session:

Set the account that all calls will use with Set-VSTeamAccount.

Set the API version that all calls will use based on your environment using Set-VSTeamAPIVersion.  Not setting this will use the default which at this time is 3.0, TFS2017.  Using the default could limit API functionality.

You can check what version of the API will be called with Get-VSTeamAPIVersion.

Optional:

Generally, once per session:

Use Set-VSTeamDefaultProject so you don't have to provide the -ProjectName parameter with the rest of the calls in the module.  However, the -ProjectName parameter is dynamic and you can use tab completion to cycle through all the projects.

Use Set-VSTeamDefaultAPITimeout to change the default timeout of 60 seconds for all calls.

## RELATED LINKS

[Get-VSTeam](Get-VSTeam.md)

[Remove-VSTeam](Remove-VSTeam.md)

[Show-VSTeam](Show-VSTeam.md)

[Update-VSTeam](Update-VSTeam.md)

[Set-VSTeamAccount](Set-VSTeamAccount.md) 

[Set-VSTeamAPIVersion](Set-VSTeamAPIVersion.md) 

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md) 

[Set-VSTeamDefaultAPITimeout](Set-VSTeamDefaultAPITimeout.md) 

