<!-- #include "./common/header.md" -->

# Get-VSTeamWorkItemType

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamWorkItemType.md" -->

## SYNTAX

## Description

<!-- #include "./synopsis/Get-VSTeamWorkItemType.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamWorkItemType -ProjectName test -WorkItemType 'Code Review Response'
```

This command gets a single work item type from the named project.

### Example 2

```powershell
Get-VSTeamWorkItemType -ProcessTemplate Basic
```

This command gets a list of the WorkItems available to projects which use the 'Basic' Template

### Example 3

```powershell
Get-VSTeamProcess scr* | Get-VSTeamWorkItemType -WorkItemType pro* | Format-Table name,processTemplate

name                 ProcessTemplate
----                 ---------------
Product Backlog Item Scrum
Product Backlog Item Scrum2
Product Backlog Item Scrum4
```

The first command in the pipeline gets the process templates with names which match SCR*, in this example 
these are "Scrum", "Scrum2" and "Scrum4". The command second finds WorkItem-Types in those processes 
which match "pro*", (each process has a "Product Backlog item" work item type) and the third command 
shows a table of Type-name and the process-template which has that type.


## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -ProcessTemplate

The Process holding the WorkItems of interest.

```yaml
Type: String
Parameter Sets: Process
```

### WorkItemType

The type of work item to retrieve.

```yaml
Type: String
Parameter Sets: ByType
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

The JSON returned has empty named items i.e.
"": "To Do"
This causes issues with the ConvertFrom-Json CmdLet.  Therefore, all "": are replaced with "_end":

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
[Add-VSTeamWorkItemType](Get-VSTeamWorkItemType.md)

[Set-VSTeamWorkItemType](Set-VSTeamWorkItemType.md)

[Remove-VSTeamWorkItemType](Remove-VSTeamWorkItemType.md)