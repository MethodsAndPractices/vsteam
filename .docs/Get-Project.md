#include "./common/header.md"

# Get-Project

## SYNOPSIS
Returns a list of projects in the Team Services or Team Foundation Server account.

## SYNTAX

### List Parameter Set
```
Get-Project [-StateFilter <String>] [-Top <Int32>] [-Skip <Int32>]
```

### ByID Parameter Set
```
Get-Project [-Id <String>] [-IncludeCapabilities]
```

### ByName Parameter Set
```
Get-Project [-ProjectName] <String>
```

## DESCRIPTION
The list of projects returned can be controlled by using the stateFilter, top
and skip parameters.

You can also get a single project by name or id.

You must call Add-TeamAccount before calling this function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-Project
```

This will return all the WellFormed team projects.

### -------------------------- EXAMPLE 2 --------------------------
```
Get-Project -top 5 | Format-Wide
```

This will return the top five WellFormed team projects only showing their name

## PARAMETERS

### -StateFilter
Returns team projects in a specific team project state of WellFormed, CreatePending, Deleting, New,
or All.
If you do not provide a value the default is WellFormed.

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: WellFormed
Accept pipeline input: False
Accept wildcard characters: False
```

### -Top
Defines the number of team projects to return. 
The default value is 100

```yaml
Type: Int32
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -Skip
Defines the number of team projects to skip. 
The default value is 0

```yaml
Type: Int32
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
The id of the project to return

```yaml
Type: String
Parameter Sets: ByID
Aliases: ProjectID

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeCapabilities
Will return additional information about the project

```yaml
Type: SwitchParameter
Parameter Sets: ByID
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#include "./params/projectName.md"

## INPUTS

### System.String

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-TeamAccount](Add-TeamAccount.md)
[Add-Project](Add-Project.md)
[Remove-Project](Remove-Project.md)

