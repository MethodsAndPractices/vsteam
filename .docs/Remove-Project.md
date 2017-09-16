#include "./common/header.md"

# Remove-Project

## SYNOPSIS
#include "./synopsis/Remove-Project.md"

## SYNTAX

```
Remove-Project [-Name] <String> [-Force]
```

## DESCRIPTION
This will permanently delete your Team Project from your Team Services
account.

This function takes a DynamicParam for ProjectName that can be read from
the Pipeline by Property Name

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Remove-Project 'MyProject'
```

You will be prompted for confirmation and the project will be deleted.

### -------------------------- EXAMPLE 2 --------------------------
```
Remove-Project 'MyProject' -Force
```

You will NOT be prompted for confirmation and the project will be deleted.

### -------------------------- EXAMPLE 3 --------------------------
```
Get-Project | Remove-Project -Force
```

This will remove all projects

## PARAMETERS

### -Force
Deletes the specified project without prompting for confirmation.
By default, Remove-Project prompts for confirmation before deleting
the project.

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

### -Name
Name of the project to remove.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-TeamAccount](Add-TeamAccount.md)
[Add-Project](Add-Project.md)

