---
external help file: Team-Help.xml
Module Name: 
online version: 
schema: 2.0.0
---

# Clear-DefaultProject

## SYNOPSIS
Clears the value stored in the default project parameter value.

## SYNTAX

```
Clear-DefaultProject [-Level <String>]
```

## DESCRIPTION
Clears the value stored in the default project parameter value.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Clear-Project
```

This will clear the default project parameter value.
You will now have to
provide a project for any functions that require a project.

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
[Add-TeamAccount](Add-TeamAccount.md)

