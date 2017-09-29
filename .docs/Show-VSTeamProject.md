#include "./common/header.md"

# Show-VSTeamProject

## SYNOPSIS
#include "./synopsis/Show-VSTeamProject.md"

## SYNTAX

### ByName (Default)
```
Show-VSTeamProject [-ProjectName] <String>
```

### ByID
```
Show-VSTeamProject [-Id <String>]
```

## DESCRIPTION
Opens the project in default browser.

You must call Add-VSTeamAccount before calling this function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Show-VSTeamProject TestProject
```

This will open a browser to the TestProject site

## PARAMETERS

### -Id
The id of the project to return.

```yaml
Type: String
Parameter Sets: ByID
Aliases: ProjectID

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#include "./params/projectName.md"

## INPUTS

### System.String

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Add-VSTeamProject](Add-VSTeamProject.md)
[Remove-VSTeamProject](Remove-VSTeamProject.md)