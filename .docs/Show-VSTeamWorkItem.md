<!-- #include "./common/header.md" -->

# Show-VSTeamWorkItem

## SYNOPSIS

<!-- #include "./synopsis/Show-VSTeamWorkItem.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Show-VSTeamWorkItem.md" -->

## EXAMPLES

### Example 1

```powershell
Show-VSTeamWorkItem -ProjectName Demo -Id 3
```

This command will open a web browser with the summary of work item 3.

## PARAMETERS

### Id

Specifies work item by ID.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases: WorkItemID
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

### vsteam_lib.WorkItem

## NOTES

You can pipe the WorkItem ID to this function.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamWorkItem](Add-VSTeamWorkItem.md)

[Get-VSTeamWorkItem](Get-VSTeamWorkItem.md)
