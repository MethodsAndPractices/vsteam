


# Update-VSTeam

## SYNOPSIS

Updates the team name, description or both.

## SYNTAX

## DESCRIPTION

Updates the team name, description or both.

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

The new description of the team

```yaml
Type: String
Position: 2
```

### -Name

The name of the team to update

```yaml
Type: String
Aliases: Id, TeamToUpdate, TeamId, TeamName
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -NewTeamName

The new name of the team

```yaml
Type: String
```

### -Confirm

Prompts you for confirmation before running the function.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
Aliases: cf
```

### -Force

Forces the function without confirmation

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
```

### -WhatIf

Shows what would happen if the function runs.
The function is not run.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
Aliases: wi
```

## INPUTS

### System.String

Description

Name

NewTeamName

## OUTPUTS

### Team.Team

## NOTES

## RELATED LINKS

