#include "./common/header.md"

# Update-Project

## SYNOPSIS
#include "./synopsis/Update-Project.md"

## SYNTAX

### ByName (Default)
```
Update-Project [[-NewName] <String>] [[-NewDescription] <String>] [-Name] <String>  [-Force]
```

### ByID
```
Update-Project [[-NewName] <String>] [[-NewDescription] <String>] [-Id] <String>  [-Force]
```

## DESCRIPTION
#include "./synopsis/Update-Project.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Update-Project -Name Demo -NewName aspDemo
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

### -Id
The id of the project to update.

```yaml
Type: String
Parameter Sets: (ByID)
Aliases: ProjectId

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

#include "./params/force.md"

#include "./params/projectName.md"

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS