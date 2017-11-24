#include "./common/header.md"

# Get-VSTeamOption

## SYNOPSIS
#include "./synopsis/Get-VSTeamOption.md"

## SYNTAX

```
Get-VSTeamOption
```

## DESCRIPTION
#include "./synopsis/Get-VSTeamOption.md"
There are two table formats defined for the Team.Option type, Default and Versions.

Default view contains Name, Area, Max Version and URI Template.

Version view contains Name, Area, Min Version, Max Version, Released Version and Resource Version.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-VSTeamOption
```

This will display all the versions of supported APIs for your account using the 'Default' table format.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Get-VSTeamOption | Format-Table -View Versions
```

This will display all the versions of supported APIs for your account using the 'Versions' custom table format.

## PARAMETERS

### -Release
Returns options for Release Management APIs

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)