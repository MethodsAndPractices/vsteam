#include "./common/header.md"

# Get-VSTeam

## SYNOPSIS
#include "./synopsis/Get-VSTeam.md"

## SYNTAX

### List (Default)
```
Get-VSTeam [-Top <Int32>] [-Skip <Int32>] [-ProjectName] <String>
```

### ByID
```
Get-VSTeam [-TeamId <String[]>] [-ProjectName] <String>
```

### ByName
```
Get-VSTeam [-Name <String[]>] [-ProjectName] <String>
```

## DESCRIPTION
#include "./synopsis/Get-VSTeam.md"

## EXAMPLES

## PARAMETERS

#include "./params/projectName.md"

### -Skip
The number of items to skip.

```yaml
Type: Int32
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TeamId
The id of the team to retrieve.

```yaml
Type: String[]
Parameter Sets: ByID
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Top
Specifies the maximum number to return.

```yaml
Type: Int32
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the team to retrieve.

```yaml
Type: String[]
Parameter Sets: ByName
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