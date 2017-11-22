#include "./common/header.md"

# Remove-VSTeamProfile

## SYNOPSIS
#include "./synopsis/Remove-VSTeamProfile.md"

## SYNTAX

```
Remove-VSTeamProfile -Name <String> [-Force]
```

## DESCRIPTION
#include "./synopsis/Remove-VSTeamProfile.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-VSTeamProfile | Remove-VSTeamProfile -Force
```

This will remove all the profiles on your system.

## PARAMETERS

### -Name
Name of profile to remove.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#include "./params/force.md"

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamProfile](Add-VSTeamProfile.md)