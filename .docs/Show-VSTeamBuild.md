#include "./common/header.md"

# Show-VSTeamBuild

## SYNOPSIS
#include "./synopsis/Show-VSTeamBuild.md"

## SYNTAX

### ByID
```
Show-VSTeamBuild [-ProjectName] <String> [-Id] <Int32>
```

## DESCRIPTION
#include "./synopsis/Show-VSTeamBuild.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Show-VSTeamBuild -ProjectName Demo -Id 3
```

This command will open a web browser with the summary of build 3.

## PARAMETERS

### -Id
Specifies build by ID.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases: BuildID

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

### You can pipe the build ID to this function.

## OUTPUTS

### Team.Build

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)
[Add-VSTeamBuild](Add-VSTeamBuild.md)
[Remove-VSTeamBuild](Remove-VSTeamBuild.md)