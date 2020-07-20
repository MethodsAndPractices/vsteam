<!-- #include "./common/header.md" -->

# Add-VsteamWorkItemState

## SYNOPSIS
<!-- #include "./synopsis/Add-VSTeamWorkItemState.md" -->

## SYNTAX

```
Add-VsteamWorkItemState [-ProcessTemplate <Object>] [-WorkItemType] <Object> [-Name] <String>
 [-StateCategory <String>] [-Color <String>] [-Order <Int32>] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Each WorkItem type in each process templates has a set of possible states.  Items may have system defined states and/or custom (user defined) states. This command adds custom states. Note that unlike system states, custom ones can only be removed not hidden.


## EXAMPLES

### Example 1
```powershell
Add-VsteamWorkItemState -WorkItemType bug -Color Blue -Name Postponed -ProcessTemplate Scrum2 -Force


Order Name      Category   Color  Customization Hidden
----- ----      --------   -----  ------------- ------
4     Postponed InProgress 0000ff custom
```

This adds a state "postponed", shown in blue, as a custom state to the "Bug" WorkItem type in the scrum process template. 
It is added in to the in-progress category - by default "Committed" is at position 3 in the list of states, as in-progress state, and 
"Done" is at postition 4 as a completed state, so this the state is inserted between them and "Done" and "Removed" each move down by one position.

## PARAMETERS

### -Color
The color for the state as a name, or a hex RGB value like ff0000 for red. Color names should tab complete.


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet. By default the cmdlet displays the confirmation prompt so this is only required if the $ConfirmPreference automatic variable has been changed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Suppresses the confirmation dialog so the command can be run without user intervention.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name for the new state.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Order
Positions the new state in the selection list. The first position in the list is 1, and if no order is specified the new state will be added at the end of the list.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProcessTemplate
Specifies the process template where the WorkItem Type to be modified is found; by default this will be the template for the current project. Note that although some WorkItem types like "bug" or "task" are found in multilple templates, a change to the available states only applies to one template, and the built-in process templates cannot be modified. Values for this parameter should tab-complete.

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

### -StateCategory
Each state fits into one of five categories: Proposed, InProgress, Resolved, Completed, or Removed. If no category is given the new state is considered to be a form of"in progress".


```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Proposed, InProgress, Resolved, Completed, Removed

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkItemType
The name of the WorkItem type whose state list is to be extended. Values for this parameter should tab-complete.


```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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
