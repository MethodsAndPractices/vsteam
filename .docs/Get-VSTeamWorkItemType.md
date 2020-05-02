<!-- #include "./common/header.md" -->

# Get-VSTeamWorkItemType

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamWorkItemType.md" -->

## SYNTAX

## Description

<!-- #include "./synopsis/Get-VSTeamWorkItemType.md" -->

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS R:\repos\vsteam> Get-WorkItemType -ProjectName test -WorkItemType 'Code Review Response'
```

This command gets a single work item type from the named project.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS R:\repos\vsteam> Get-VSTeamWorkItemType -ProcessTemplate Basic
```

This command gets a list of the work items available to projects which use the 'Basic' Template


### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS R:\repos\vsteam> Get-VSTeamProcess scr* |  Get-VSTeamWorkItemType  -WorkItemType pro* | ft name,processtemplate
name                 ProcessTemplate
----                 ---------------
Product Backlog Item Scrum
Product Backlog Item Scrum2
Product Backlog Item Scrum4

```

The first command gets a the process templates which match SCR*. The second finds WorkItem Types 
in those process which match "pro*", and the third shows a table of Type name and process template with that type

### -------------------------- EXAMPLE 4 --------------------------

```PowerShell
PS R:\repos\vsteam> $t = Get-VSTeamWorkItemType -ProcessTemplate Basic -WorkItemType Task -Expand layout
PS R:\repos\vsteam> $t.layout.pages.labels
```

The first command gets a single work item in the 'Basic' Template, and requests its layout information.
The second command displays the names of the pages used in the layout ('Details', 'History', 'Links', 'Attachments')

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -ProcessTemplate

The type of the Process holding the WorkItems of interest.

```yaml
Type: String
Parameter Sets: Process
```
### -WorkItemType

The type of work item to retrieve.

```yaml
Type: String
Aliases: Name
```


### -Expand

If specified the workitem(s) returned will have behavior and/or layout and/or state information attached.

```yaml
Type: String[]
Parameter Sets: Process
Accepted values: 'behaviors','layout','states'
```


## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

The JSON returned has empty named items i.e.
"": "To Do"
This causes issues with the ConvertFrom-Json CmdLet.  Therefore, all "": are replaced with "_end":

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)
