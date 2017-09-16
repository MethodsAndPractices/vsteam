#include "./common/header.md"

# Get-BuildDefinition

## SYNOPSIS
Gets the build defintions for a team project.

## SYNTAX

### UNNAMED_PARAMETER_SET_1
```
Get-BuildDefinition [-ProjectName] <String> [-Filter <String>] [-Type <String>]
```

### UNNAMED_PARAMETER_SET_2
```
Get-BuildDefinition [-ProjectName] <String> -Id <Int32[]> [-Revision <Int32>]
```

## DESCRIPTION
The Get-BuildDefinition function gets the build defintions for a team
project.
The project name is a Dynamic Parameter which may not be displayed
in the syntax above but is mandatory.

With just a project name, this function gets all of the build definitions
for that team project.
You can also specify a particular build defintion
by ID.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-BuildDefinition -ProjectName Demo | Format-List *
```

This command gets a list of all build definitions in the demo project.
The
pipeline operator (|) passes the data to the Format-List cmdlet, which
displays all available properties (*) of the build defintion objects.

## PARAMETERS

### -Filter
Filters to definitions whose names equal this value.
Append a * to filter to
definitions whose names start with this value.
For example: MS*.

```yaml
Type: String
Parameter Sets: UNNAMED_PARAMETER_SET_1
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of the build definitions to retrieve (build, xaml).
If not
specified, all types will be returned.

```yaml
Type: String
Parameter Sets: UNNAMED_PARAMETER_SET_1
Aliases: 

Required: False
Position: Named
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

#include "./params/projectName.md"

### -Id
Specifies one or more build defintions by ID.
To specify multiple IDs, use
commas to separate the IDs.
To find the ID of a build defintion, type
Get-BuildDefinition.

```yaml
Type: Int32[]
Parameter Sets: UNNAMED_PARAMETER_SET_2
Aliases: BuildDefinitionID

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Revision
Specifies the specific revision number of the definition to retrieve.

```yaml
Type: Int32
Parameter Sets: UNNAMED_PARAMETER_SET_2
Aliases: 

Required: False
Position: Named
Default value: -1
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### You can pipe build defintion IDs to this function.

## OUTPUTS

### Team.BuildDefinition

## NOTES

## RELATED LINKS

[Add-TeamAccount](Add-TeamAccount.md)
[Set-DefaultProject](Set-DefaultProject.md)
[Add-BuildDefinition](Add-BuildDefinition.md)
[Remove-BuildDefinition](Remove-BuildDefinition.md)

