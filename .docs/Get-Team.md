#include "./common/header.md"

# Get-Team

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

### List (Default)
```
Get-Team [-Top <Int32>] [-Skip <Int32>] [-ProjectName] <String>
```

### ByID
```
Get-Team [-TeamId <String[]>] [-ProjectName] <String>
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

#include "./params/projectName.md"

### -Skip
{{Fill Skip Description}}

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
{{Fill TeamId Description}}

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
{{Fill Top Description}}

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

## INPUTS

### System.String


## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

