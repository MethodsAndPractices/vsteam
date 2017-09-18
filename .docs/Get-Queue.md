#include "./common/header.md"

# Get-Queue

## SYNOPSIS
#include "./synopsis/Get-Queue.md"

## SYNTAX

### List (Default)
```
Get-Queue [-ProjectName] <String> [-QueueName <String>] [-ActionFilter <String>]
```

### ByID
```
Get-Queue [-ProjectName] <String> [-Id <String>]
```

## DESCRIPTION
#include "./synopsis/Get-Queue.md"

## EXAMPLES

## PARAMETERS

### -QueueName
Name of the queue to return.

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

#include "./params/projectName.md"

### -Id
Id of the queue to return.

```yaml
Type: String
Parameter Sets: ByID
Aliases: QueueID

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