#include "./common/header.md"

# Get-Project

## SYNOPSIS
Returns a list of projects in the Team Services or Team Foundation Server account.

## SYNTAX

### UNNAMED_PARAMETER_SET_1
```
Get-Project [-StateFilter <String>] [-Top <Int32>] [-Skip <Int32>]
```

### UNNAMED_PARAMETER_SET_2
```
Get-Project [-Id <String>] [-IncludeCapabilites]
```

### UNNAMED_PARAMETER_SET_3
```
Get-Project [-Name] <String>
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
Parameter Sets: UNNAMED_PARAMETER_SET_1
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
Parameter Sets: UNNAMED_PARAMETER_SET_1
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
Parameter Sets: UNNAMED_PARAMETER_SET_1
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
Parameter Sets: UNNAMED_PARAMETER_SET_2
Aliases: ProjectID

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeCapabilites
Will return additional information about the project

```yaml
Type: SwitchParameter
Parameter Sets: UNNAMED_PARAMETER_SET_2
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
@{Text=}

```yaml
Type: String
Parameter Sets: UNNAMED_PARAMETER_SET_3
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-TeamAccount](Add-TeamAccount.md)
[Add-Project](Add-Project.md)
[Remove-Project](Remove-Project.md)

