


# Show-VSTeamWorkItem

## SYNOPSIS

Opens the work item in the default browser.

## SYNTAX

## DESCRIPTION

Opens the work item in the default browser.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
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
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

### Team.WorkItem

## NOTES

You can pipe the WorkItem ID to this function.

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamWorkItem](Add-VSTeamWorkItem.md)

[Get-VSTeamWorkItem](Get-VSTeamWorkItem.md)

