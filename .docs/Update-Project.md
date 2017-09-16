#include "./common/header.md"

# Update-Project

## SYNOPSIS
#include "./synopsis/Update-Project.md"

## SYNTAX

```
Update-Project [-Name] <String> [[-NewName] <String>] [[-NewDescription] <String>]
```

## DESCRIPTION
You can pass just name, description or both.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Update-Project -Name Demo -NewName aspDemo
```

This command changes the name of your project from Demo to aspDemo.

## PARAMETERS

### -NewName
The new name for the project.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewDescription
The new description for the project.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-DefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

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

### System.Object

## NOTES

## RELATED LINKS

