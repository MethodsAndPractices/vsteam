<!-- #include "./common/header.md" -->

# Get-VsteamWorkItemState

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamWorkItemState.md" -->

## SYNTAX

```
Get-VsteamWorkItemState [-ProcessTemplate <Object>] [-WorkItemType] <Object> [<CommonParameters>]
```

## DESCRIPTION
Each WorkItem type in each process templates has a set of possible states, each belongs to a category which represents a stage in the item's lifecycle (Proposed, In-Progress, Completed, Resolved, Removed) and each has a color. Items may have system defined states and/or custom (user defined) states. Get-VsteamWorkItemState lists the available states.

## EXAMPLES


### Example 2
```powershell
PS C:\> Get-VsteamWorkItemState  -WorkItemType Bug

Order Name      Category   Color  Customization Hidden
----- ----      --------   -----  ------------- ------
1     New       Proposed   b2b2b2 system
2     Approved  Proposed   b2b2b2 system
3     Committed InProgress 007acc system
4     Done      Completed  339933 system
5     Removed   Removed    ffffff system
```
This lists the states for the built in WorkItem type "bug" in the current project
Notice that the states all have a customization of system; therse states can be hidden but not removed.

### Example 2
```powershell
PS C:\> Get-VsteamWorkItemState -ProcessTemplate Scrum4 -WorkItemType 'Update'

Order Name      Category   Color  Customization Hidden
----- ----      --------   -----  ------------- ------
1     New       Proposed   b2b2b2 custom
2     Committed InProgress 007acc custom
3     Done      Completed  339933 custom
4     Failed    Removed    ff0000 custom

```
This lists the states for the custom WorkItem type "update" in the custom process "Scrum4".
Notice that the states all have a customization of custom; therse states can be removed but hidden.

### Example 3
```powershell
Get-VSTeamProcess | Get-VSTeamWorkItemType -WorkItemType bug | Get-VsteamWorkItemState | Sort-object name,processtemplate|  Format-table ProcessTemplate,WorkItemType,Order,name,Color -AutoSize


ProcessTemplate WorkItemType order name      color
--------------- ------------ ----- ----      -----
Agile           Bug              2 Active    007acc
CMMI            Bug              2 Active    007acc
Scrum           Bug              2 Approved  b2b2b2
...
```
This command gets all the process templates, gets the "bug" WorkItem type in each one, and gets the states available for all the different versions of bug. It sorts the results to group the sates together - and formats the results as a table.
This shows that In the default "Agile" and "CMMI" templates bugs have a state of "Active" but do not have "Approved", but the reverse is true in the "Scrum" template.


### Example 3
```powershell
Get-VSTeamProcess | Get-VSTeamWorkItemType | Get-VsteamWorkItemState | where {$_.hidden} |  Format-table ProcessTemplate,WorkItemType,Order,name,Color

ProcessTemplate WorkItemType order name    color
--------------- ------------ ----- ----    -----
Scrum2          Epic             6 Removed ffffff

```
This command gets all the process templates, and all their WorkItem types and gets system states which have been hidden, formatting the result as a table.
In the example, the custom template "Scrum2" has hidden the "Removed" state for Epics.

## PARAMETERS

### -ProcessTemplate
Specifies the process template where the WorkItem Type is found; by default this will be the template for the current project. Note that although some WorkItem types like "bug" or "task" are found in multilple templates, a change to the available states only applies to one template. Values for this parameter should tab-complete.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WorkItemType
The name of the WorkItem type whose states are required. Values for this parameter should tab-complete.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
