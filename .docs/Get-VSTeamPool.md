#include "./common/header.md"

# Get-VSTeamPool

## SYNOPSIS
#include "./synopsis/Get-VSTeamPool.md"

## SYNTAX

### List (Default)
```
Get-VSTeamPool [-PoolName <String>] [-ActionFilter <String>]
```

### ByID
```
Get-VSTeamPool -Id <String>
```

## DESCRIPTION
#include "./synopsis/Get-VSTeamPool.md"

## EXAMPLES

## PARAMETERS

### -PoolName
Name of the pool to return.

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActionFilter
None, Manage or Use.

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Id of the pool to return.

```yaml
Type: String
Parameter Sets: ByID
Aliases: PoolID

Required: True
Position: Named
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