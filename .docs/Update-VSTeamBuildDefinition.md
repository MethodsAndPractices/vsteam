#include "./common/header.md"

# Update-VSTeamBuildDefinition

## SYNOPSIS
#include "./synopsis/Update-VSTeamBuildDefinition.md"

## SYNTAX

```
Update-VSTeamBuildDefinition [-ProjectName] <String> [-Id] <Int32> [-InFile] <String> [-Force]
```

## DESCRIPTION
Reads a JSON file off disk and uses that file to update an existing
build defintion in the provided project.

You must call Add-VSTeamAccount before calling this function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Update-VSTeamBuildDefinition -ProjectName Demo -Id 123 -InFile build.json
```

This command reads build.json and updates existing build defintion with
id 123 from it on the demo team project.

## PARAMETERS

### -Id
Specifies the build definition to update by ID.

To find the ID of a build defintion, type Get-VSTeamBuildDefinition.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -InFile
Specifies the JSON file that contains the updated build defintion.
Enter a path and file name.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

#include "./params/projectName.md"

## INPUTS

### System.Int32
### System.String

## OUTPUTS

### None

## NOTES
This function has a Dynamic Parameter for ProjectName that specifies the
project for which this function gets build definitions.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS