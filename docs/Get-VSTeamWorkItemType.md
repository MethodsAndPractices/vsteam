


# Get-VSTeamWorkItemType

## SYNOPSIS

Gets a list of all work item types or a single work item type.

## SYNTAX

## Description

Gets a list of all work item types or a single work item type.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS R:\repos\vsteam> Get-WorkItemType -ProjectName test -WorkItemType 'Code Review Response'
```

This command gets a single WorkItem type from the named project.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS R:\repos\vsteam> Get-VSTeamWorkItemType -ProcessTemplate Basic
```

This command gets a list of the WorkItems available to projects which use the 'Basic' Template

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS R:\repos\vsteam> Get-VSTeamProcess scr* | Get-VSTeamWorkItemType -WorkItemType pro* | ft name,processTemplate

name                 ProcessTemplate
----                 ---------------
Product Backlog Item Scrum
Product Backlog Item Scrum2
Product Backlog Item Scrum4

```

The first command gets a the process templates which match SCR*. The second finds WorkItem Types in those process which match "pro*", and the third shows a table of Type name and process template with that type

### -------------------------- EXAMPLE 4 --------------------------

```PowerShell
PS R:\repos\vsteam> $t = Get-VSTeamWorkItemType -ProcessTemplate Basic -WorkItemType Task -Expand layout
PS R:\repos\vsteam> $t.layout.pages.labels
```

The first command gets a single WorkItem in the 'Basic' Template, and requests its layout information. The second command displays the names of the pages used in the layout ('Details', 'History', 'Links', 'Attachments')

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 0
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -ProcessTemplate

The Process holding the WorkItems of interest.

```yaml
Type: String
Parameter Sets: Process
```

### -WorkItemType

The type of WorkItem to retrieve.

```yaml
Type: String
Aliases: Name
```

### -Expand

If specified the work item(s) returned will have behavior and/or layout and/or state information attached.

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

