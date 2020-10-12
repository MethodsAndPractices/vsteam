<!-- #include "./common/header.md" -->

# Set-VSTeamWorkItemBehavior

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamWorkItemBehavior.md" -->

## SYNTAX

## Description

Modifies a the Portfolio backlog (a.k.a behavior) associated with a WorkItem type in a custom Process Template. This allows an item to be added to board (as its default item or not), or removed from the board.
Note (1) System-defined backlogs have WorkItem types associated with them which cannot be removed.
Note (2) The first item added to a custom backlog from the UI will be set as the default, this needs to be specified explicitly when adding items from the commandline.

## EXAMPLES

### Example 1

```powershell
 Set-VSTeamWorkItemBehavior -ProcessTemplate Scrum5 -WorkItemType Impediment -Behavior Epics

Confirm
Are you sure you want to perform this action?
Performing the operation "Modify Scrum5 to update definition of workitem type" on target "Impediment".
[Y] Yes [A] Yes to All [N] No [L] No to All [S] Suspend [?] Help (default is "Yes"): y

ProcessTemplate WorkItemType Behavior                                 IsDefault
--------------- ------------ --------                                 ---------
Scrum5          Impediment   Microsoft.VSTS.Scrum.EpicBacklogBehavior     False
```
This command addes the Impediment WorkItem type to the Epics board in the custom process template named "Scrum5". It leaves the default workitem type as "Epic". The -Force switch has not been specified so the command prompts for confirmation


### Example 2

```powershell
 Set-VSTeamWorkItemBehavior -ProcessTemplate Scrum5 -WorkItemType Impediment -Remove -force

```
This undoes the previous example without pausing for confirmation. Note removing the default WorkItem type from the behavior will promote another to be the default. To promote a non-default WorkItem type to be the default it must be removed and re-added.

## PARAMETERS


### -Confirm

Prompts you for confirmation before running the cmdlet. Normally the command will prompt for confirmation and -Confirm is only needed if \$ConfirmPreference has been changed.

<!-- #include "./params/force.md" -->


### -Behavior

Current name of the behavior / backlog. Either the display name or the reference name may be used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProcessTemplate

The process template to modify containing the WorkItem type to be updated. Note that the built-in templates ("Scrum", "Agile" etc.) cannot be modified, only custom templates (derived from the built-in ones) can be changed.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsDefault
If specified when adding a behavior to a WorkItem type, makes that type the default for new items added on the board in question. Note that this can only be specified when adding a behavior.

```yaml
Type: SwitchParameter
Parameter Sets: AddOrSet
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```


### -Remove
If specified removes any existing behavior from the WorkItem type. This is necessary before moving a custom type from one board to another, or promoting an item which is attached to one board to be the default for that board.

```yaml
Type: SwitchParameter
Parameter Sets: Delete
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkItemType
The name of the WorkItem type to modify. Behaviors cannot be set for Bug, or for pre-exisitng Test types, and the WorkItem types bound to the system-created boards cannot removed from them; although other items can be added as the default and the system-created types can be be set to disabled.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

<!-- #include "./params/whatIf.md" -->

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
[Get-Set-VSTeamWorkItemBehavior](Get-Set-VSTeamWorkItemBehavior.md)

[Get-VSTeamProcessBehavior](Get-VSTeamProcessBehavior.md)
