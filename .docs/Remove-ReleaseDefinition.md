#include "./common/header.md"

# Remove-ReleaseDefinition

## SYNOPSIS
#include "./synopsis/Remove-ReleaseDefinition.md"

## SYNTAX

```
Remove-ReleaseDefinition [-ProjectName] <String> [-Id] <Int32[]> [-Force]
```

## DESCRIPTION
The Remove-ReleaseDefinition function removes the release definitions for a
team project.
The project name is a Dynamic Parameter which may not be
displayed in the syntax above but is mandatory.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-ReleaseDefinition -ProjectName demo | Remove-ReleaseDefinition
```

This command gets a list of all release definitions in the demo project.
The
pipeline operator (|) passes the data to the Remove-ReleaseDefinition
function, which removes each release defintion object.

## PARAMETERS

### -Id
Specifies one or more release definitions by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release defintion, type Get-ReleaseDefinition.

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

#include "./params/force.md"

#include "./params/projectName.md"

## INPUTS

### You can pipe release defintion IDs to this function.

## OUTPUTS

### None

## NOTES
This function has a Dynamic Parameter for ProjectName that specifies the
project for which this function gets release definitions.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)
[Add-ReleaseDefinition](Add-ReleaseDefinition.md)
[Get-ReleaseDefinition](Get-ReleaseDefinition.md)