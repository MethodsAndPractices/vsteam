#include "./common/header.md"

# Remove-Release

## SYNOPSIS
#include "./synopsis/Remove-Release.md"

## SYNTAX

```
Remove-Release [-ProjectName] <String> [-Id] <Int32[]> [-Force]
```

## DESCRIPTION
The Remove-Release function removes the releases for a
team project.

The project name is a Dynamic Parameter which may not be
displayed in the syntax above but is mandatory.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-Release -ProjectName demo | Remove-Release
```

This command gets a list of all release s in the demo project.

The pipeline operator (|) passes the data to the Remove-Release
function, which removes each release defintion object.

## PARAMETERS

### -Id
Specifies one or more releases by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release defintion, type Get-Release.

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
project for which this function gets release s.

You can tab complete from a list of available projects.

You can use Set-DefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

[Add-TeamAccount](Add-TeamAccount.md)
[Set-DefaultProject](Set-DefaultProject.md)
[Add-Release](Add-Release.md)
[Get-Release](Get-Release.md)