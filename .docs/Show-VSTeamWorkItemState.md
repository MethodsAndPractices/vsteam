<!-- #include "./common/header.md" -->

# Show-VSTeamWorkItemState

## SYNOPSIS

<!-- #include "./synopsis/Show-VSTeamWorkItemState.md" -->

## SYNTAX

## DESCRIPTION

Each WorkItem type in each process templates has a set of possible states.  Items may have system defined states and/or custom (user defined) states. System states cannot be removed, but can be hidden and this command is used to un-hide states which have previously been hidden

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Show-VSTeamWorkItemState -WorkItemType Bug -Name Approved -ProcessTemplate Scrum2 -Force
```

This un-hides the "Approved" state for bug in the custom process template "Scrum2", without the confirmation prompt.
If the state is not hidden a warning message will appear and the state will not be changed.

## PARAMETERS

### -Name

The name of the hidden state to be revealed

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
Position: Named
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
