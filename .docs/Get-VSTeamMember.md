#include "./common/header.md"

# Get-VSTeamMember

## SYNOPSIS
#include "./synopsis/Get-VSTeamMember.md"

## SYNTAX

```
Get-VSTeamMember [[-Top] <Int32>] [[-Skip] <Int32>] [-TeamId] <String> [-ProjectName] <String>
```

## DESCRIPTION
#include "./synopsis/Get-VSTeamMember.md"

## EXAMPLES

## PARAMETERS

#include "./params/projectName.md"

### -Skip
The number of items to skip.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TeamId
The id of the team to search.

```yaml
Type: String
Parameter Sets: (All)
Aliases: name

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Top
Specifies the maximum number to return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String


## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS