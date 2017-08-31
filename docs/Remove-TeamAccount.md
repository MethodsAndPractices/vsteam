---
external help file: Team-Help.xml
Module Name: 
online version: 
schema: 2.0.0
---

# Remove-TeamAccount

## SYNOPSIS
Clears your default project, account name and personal access token.

## SYNTAX

```
Remove-TeamAccount [-Force] [-Level <String>]
```

## DESCRIPTION
Clears the environment variables that hold your default project, account and personal access token.
You have to run Add-TeamAccount again before calling any other functions.

To remove from the Machine level you must be running PowerShell as administrator.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Remove-TeamAccount
```

This will clear your account name and personal access token.

## PARAMETERS

### -Level
On Windows allows you to clear your account information at the Process, User or Machine levels.

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

### -Force
Forces the command without confirmation

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-TeamAccount](Add-TeamAccount.md)

