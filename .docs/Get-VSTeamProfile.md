#include "./common/header.md"

# Get-VSTeamProfile

## SYNOPSIS
#include "./synopsis/Get-VSTeamProfile.md"

## SYNTAX

```
Get-VSTeamProfile [[-Name] <String>]
```

## DESCRIPTION
#include "./synopsis/Get-VSTeamProfile.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-VSTeamProfile
```

Return the list of saved profiles

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Get-VSTeamProfile -Name mydemos
```

Will return details of the profile provided

## PARAMETERS

### -Name
Optional name for the profile.

```yaml
Type: String
Parameter Sets: All
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Add-VSTeamProfile](Add-VSTeamProfile.md)