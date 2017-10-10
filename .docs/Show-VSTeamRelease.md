#include "./common/header.md"

# Show-VSTeamRelease

## SYNOPSIS
#include "./synopsis/Show-VSTeamRelease.md"

## SYNTAX

### ByID
```
Show-VSTeamRelease [-ProjectName] <String> [-Id] <Int32>
```

## DESCRIPTION
#include "./synopsis/Show-VSTeamRelease.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Show-VSTeamRelease -ProjectName Demo -Id 3
```

This command will open a web browser with the summary of release 3.

## PARAMETERS

### -Id
Specifies release by ID.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases: ReleaseID

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

### You can pipe the release ID to this function.

## OUTPUTS

### Team.Release

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)
[Add-VSTeamRelease](Add-VSTeamRelease.md)
[Remove-VSTeamRelease](Remove-VSTeamRelease.md)