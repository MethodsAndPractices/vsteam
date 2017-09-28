#include "./common/header.md"

# Remove-VSTeamBuildDefinition

## SYNOPSIS
#include "./synopsis/Remove-VSTeamBuildDefinition.md"

## SYNTAX

```
Remove-VSTeamBuildDefinition [-ProjectName] <String> [-Id] <Int32[]> [-Force]
```

## DESCRIPTION
The Remove-VSTeamBuildDefinition function removes the build definitions for a
team project.

The project name is a Dynamic Parameter which may not be
displayed in the syntax above but is mandatory.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-VSTeamBuildDefinition -ProjectName Demo | Remove-VSTeamBuildDefinition
```

This command gets a list of all build definitions in the demo project.

The pipeline operator (|) passes the data to the Remove-VSTeamBuildDefinition
function, which removes each build defintion object.

## PARAMETERS

### -Id
Specifies one or more build definitions by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a build defintion, type Get-VSTeamBuildDefinition.

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

### You can pipe build defintion IDs to this function.

## OUTPUTS

### None

## NOTES
This function has a Dynamic Parameter for ProjectName that specifies the
project for which this function gets build definitions.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)
[Add-VSTeamBuildDefinition](Add-VSTeamBuildDefinition.md)
[Get-VSTeamBuildDefinition](Get-VSTeamBuildDefinition.md)