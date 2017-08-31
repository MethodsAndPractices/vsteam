---
external help file: Team-Help.xml
Module Name: 
online version: 
schema: 2.0.0
---

# Remove-ReleaseDefinition

## SYNOPSIS
Removes the release defintions for a team project.

## SYNTAX

```
Remove-ReleaseDefinition [-ProjectName] <String> [-Id] <Int32[]> [-Force]
```

## DESCRIPTION
The Remove-ReleaseDefinition function removes the release defintions for a
team project.
The project name is a Dynamic Parameter which may not be
displayed in the syntax above but is mandatory.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-ReleaseDefinition -ProjectName demo | Remove-ReleaseDefinition
```

This command gets a list of all release definitions in the demo project.
The
pipeline operator (|) passes the data to the Remove-ReleaseDefinition
function, which removes each release defintion object.

## PARAMETERS

### -Id
Specifies one or more release defintions by ID.
To specify multiple IDs, use
commas to separate the IDs.
To find the ID of a release defintion, type
Get-ReleaseDefinition.

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
Removes the specified release defintion without prompting for confirmation.
By default, Remove-ReleaseDefinition prompts for confirmation before
removing any release defintion.

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

### You can pipe release defintion IDs to this function.

## OUTPUTS

### None

## NOTES
This function has a Dynamic Parameter for ProjectName that specifies the
project for which this function gets release definitions.

You can tab complete from a list of avaiable projects.

You can use Set-DefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

[Add-TeamAccount](Add-TeamAccount.md)
[Set-DefaultProject](Set-DefaultProject.md)
[Add-ReleaseDefinition](Add-ReleaseDefinition.md)
[Get-ReleaseDefinition](Get-ReleaseDefinition.md)

