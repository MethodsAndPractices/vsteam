


# Remove-VSTeam

## SYNOPSIS

Removes a team from a project.

## SYNTAX

## DESCRIPTION

Removes a team from a project.

## EXAMPLES

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

### -TeamId

The id of the team to remove.

```yaml
Type: String
Aliases: name
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Aliases: cf
```

### -Force

Forces the command without confirmation

```yaml
Type: SwitchParameter
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Aliases: wi
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS