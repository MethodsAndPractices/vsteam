<!-- #include "./common/header.md" -->

# Hide-VSTeamWorkItemState

## SYNOPSIS
<!-- #include "./synopsis/Hide-VSTeamWorkItemState.md" -->

## SYNTAX

## DESCRIPTION

Each WorkItem type in each process templates has a set of possible states.  Items may have system defined states and/or custom (user defined) states. System states cannot be removed, but can be hidden and this command is used to hide them

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Hide-VSTeamWorkItemState -WorkItemType Bug -Name Approved

Confirm
Are you sure you want to perform this action?
Performing the operation "Modify WorkItem type 'Bug' in process template 'Scrum'; hide state" on target "Approved".
[Y] Yes [A] Yes to All [N] No [L] No to All [S] Suspend [?] Help (default is "Yes"): y
WARNING: An error occurred: Response status code does not indicate success: 403 (Forbidden).
WARNING: VS402356: You do not have the permissions required to perform the attempted operation on this process.
```

In this example the user has tried to hide the state "Approved" for bugs in the current project's template. -Force has not been specified and the confirmation prompt says that the process template to be modified is "Scrum". This is a built-in template and WorkItem types and their states are read only. The user continues and an error occurs (the full error is not shown) because changing the process is forbidden.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Hide-VSTeamWorkItemState -WorkItemType Bug -Name Approved -ProcessTemplate Scrum2 -Force

Order Name     Category Color  Customization Hidden
----- ----     -------- -----  ------------- ------
6     Approved Proposed b2b2b2 inherited     True
```

This version hides the state "Approved" for bugs in the custom template named Scrum2. -Force has specified to skip the confirmation, and the command returns the modified state. Notice that the customization column changes from "system" to "inherited" when a state is hidden.

If the state is already hidden a warning message will appear and the state will not be changed.

## PARAMETERS

### -Name

The name of the state to be hidden

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ProcessTemplate

Specifies the process template where the WorkItem Type to be modified is found; by default this will be the template for the current project. Note that although some WorkItem types like "bug" or "task" are found in multiple templates, a change to the available states only applies to one template, and the built-in process templates cannot be modified. Values for this parameter should tab-complete.

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

The name of the WorkItem type whose state is to be modified. Values for this parameter should tab-complete.

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

<!-- #include "./params/confirm.md" -->

<!-- #include "./params/force.md" -->

<!-- #include "./params/whatif.md" -->

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
