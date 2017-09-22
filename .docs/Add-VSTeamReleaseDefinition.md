#include "./common/header.md"

# Add-VSTeamReleaseDefinition

## SYNOPSIS
#include "./synopsis/Add-VSTeamReleaseDefinition.md"

## SYNTAX

```
Add-VSTeamReleaseDefinition [-ProjectName] <String> [-InFile] <String>
```

## DESCRIPTION
Reads a JSON file off disk and uses that file to create a new release defintion
in the provided project.

You must call Add-VSTeamAccount before calling this function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Add-VSTeamReleaseDefinition -ProjectName demo -inFile release.json
```

This command reads release.json and creates a new release defintion from it
on the demo team project.

## PARAMETERS

### -InFile
Specifies the JSON file that contains the release defintion to be created.
Enter
a path and file name.

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

#include "./params/projectName.md"

## INPUTS

### System.String

## OUTPUTS

## NOTES
This function has a Dynamic Parameter for ProjectName that specifies the
project for which this function gets release definitions.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

