#include "./common/header.md"

# Update-VSTeam

## SYNOPSIS
#include "./synopsis/Update-VSTeam.md"

## SYNTAX

```
Update-VSTeam [-Name] <String> [[-NewTeamName] <String>] [[-Description] <String>] [-ProjectName] <String> [-Force] [-WhatIf] [-Confirm]
```

## DESCRIPTION
#include "./synopsis/Update-VSTeam.md"

## EXAMPLES

## PARAMETERS

### -Description
The new description of the team

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the team to update

```yaml
Type: String
Parameter Sets: (All)
Aliases: Id, TeamToUpdate, TeamId, TeamName

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -NewTeamName
The new name of the team

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

#include "./params/confirm.md"

#include "./params/force.md"

#include "./params/projectName.md"

#include "./params/whatIf.md"

## INPUTS

### System.String


## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS