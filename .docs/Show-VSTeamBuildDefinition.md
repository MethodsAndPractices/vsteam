#include "./common/header.md"

# Show-VSTeamBuildDefinition

## SYNOPSIS
#include "./synopsis/Show-VSTeamBuildDefinition.md"

## SYNTAX

### List (Default)
```
Show-VSTeamBuildDefinition [-ProjectName] <String> [-Filter <String>] [-Type <String>]
```

### ByID
```
Show-VSTeamBuildDefinition [-ProjectName] <String> -Id <Int32>
```

## DESCRIPTION
#include "./synopsis/Show-VSTeamBuildDefinition.md"

The project name is a Dynamic Parameter which may not be displayed
in the syntax above but is mandatory.

With just a project name, this function shows all of the build definitions
for that team project.

You can also specify a particular build defintion
by ID.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Show-VSTeamBuildDefinition -ProjectName Demo
```

This command will open a web browser with All Definitions for this project showing.

## PARAMETERS

### -Type
The type of the build definitions to retrieve (Mine, All, Queued, XAML).

If not specified, all types will be returned.

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

#include "./params/projectName.md"

### -Id
Specifies build definition by ID.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases: BuildDefinitionID

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

### You can pipe build defintion IDs to this function.

## OUTPUTS

### Team.BuildDefinition

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)
[Add-VSTeamBuildDefinition](Add-VSTeamBuildDefinition.md)
[Remove-VSTeamBuildDefinition](Remove-VSTeamBuildDefinition.md)