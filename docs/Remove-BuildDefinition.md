---
external help file: Team-Help.xml
Module Name: 
online version: 
schema: 2.0.0
---

# Remove-BuildDefinition

## SYNOPSIS
Removes the build defintions for a team project.

## SYNTAX

```
Remove-BuildDefinition [-ProjectName] <String> [-Id] <Int32[]> [-Force]
```

## DESCRIPTION
The Remove-BuildDefinition function removes the build defintions for a
team project.
The project name is a Dynamic Parameter which may not be
displayed in the syntax above but is mandatory.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-BuildDefinition -ProjectName Demo | Remove-BuildDefinition
```

This command gets a list of all build definitions in the demo project.
The
pipeline operator (|) passes the data to the Remove-BuildDefinition
function, which removes each build defintion object.

## PARAMETERS

### -Id
Specifies one or more build defintions by ID.
To specify multiple IDs, use
commas to separate the IDs.
To find the ID of a build defintion, type
Get-BuildDefinition.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Force
Removes the specified build defintion without prompting for confirmation.
By default, Remove-BuildDefinition prompts for confirmation before
removing any build defintion.

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

### -ProjectName
Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-DefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

### You can pipe build defintion IDs to this function.

## OUTPUTS

### None

## NOTES
This function has a Dynamic Parameter for ProjectName that specifies the
project for which this function gets build definitions.

You can tab complete from a list of avaiable projects.

You can use Set-DefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

[Add-TeamAccount](Add-TeamAccount.md)
[Set-DefaultProject](Set-DefaultProject.md)
[Add-BuildDefinition](Add-BuildDefinition.md)
[Get-BuildDefinition](Get-BuildDefinition.md)

