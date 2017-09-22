#include "./common/header.md"

# Clear-VSTeamDefaultProject

## SYNOPSIS
#include "./synopsis/Clear-VSTeamDefaultProject.md"

## SYNTAX

```
Clear-VSTeamDefaultProject [-Level <String>]
```

## DESCRIPTION
Clears the value stored in the default project parameter value.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Clear-Project
```

This will clear the default project parameter value.
You will now have to provide a project for any functions that require a project.

## PARAMETERS

### -Level
On Windows allows you to clear your default project at the Process, User or Machine levels.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Set-Project](Set-Project.md)
[Add-VSTeamAccount](Add-VSTeamAccount.md)

