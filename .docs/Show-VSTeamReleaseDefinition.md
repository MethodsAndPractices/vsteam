#include "./common/header.md"

# Show-VSTeamReleaseDefinition

## SYNOPSIS
#include "./synopsis/Show-VSTeamReleaseDefinition.md"

## SYNTAX

```
Show-VSTeamReleaseDefinition [-ProjectName] <String> -Id <Int32>
```

## DESCRIPTION
#include "./synopsis/Show-VSTeamReleaseDefinition.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Show-VSTeamReleaseDefinition -ProjectName Demo
```

This command will open a web browser with All Release Definitions for this project showing.

## PARAMETERS

#include "./params/projectName.md"

### -Id
Specifies release definition by ID.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases: ReleaseDefinitionID

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

### You can pipe the release defintion ID to this function.

## OUTPUTS

### Team.ReleaseDefinition

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)
[Add-VSTeamReleaseDefinition](Add-VSTeamReleaseDefinition.md)
[Remove-VSTeamReleaseDefinition](Remove-VSTeamReleaseDefinition.md)