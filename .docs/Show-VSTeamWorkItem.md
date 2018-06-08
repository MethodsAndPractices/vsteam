#include "./common/header.md"

# Show-VSTeamWorkItem

## SYNOPSIS
#include "./synopsis/Show-VSTeamWorkItem.md"

## SYNTAX

### ByID
```
Show-VSTeamWorkItem [-ProjectName] <String> [-Id] <Int32>
```

## DESCRIPTION
#include "./synopsis/Show-VSTeamWorkItem.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Show-VSTeamWorkItem -ProjectName Demo -Id 3
```

This command will open a web browser with the summary of work item 3.

## PARAMETERS

### -Id
Specifies work item by ID.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases: WorkItemID

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

### You can pipe the WorkItem ID to this function.

## OUTPUTS

### Team.WorkItem

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)
[Add-VSTeamWorkItem](Add-VSTeamWorkItem.md)
[Get-VSTeamWorkItem](Get-VSTeamWorkItem.md)