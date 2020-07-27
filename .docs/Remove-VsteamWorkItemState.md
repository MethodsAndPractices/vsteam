<!-- #include "./common/header.md" -->

# Remove-VSTeamWorkItemState

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamWorkItemState.md" -->

## SYNTAX

## DESCRIPTION

Each WorkItem type in each process templates has a set of possible states.  Items may have system defined states and/or custom (user defined) states. This command removes custom states. Note that system states, cannot be removed but can be hidden.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Remove-VSTeamWorkItemState -WorkItemType Bug  -Name postponed -ProcessTemplate Scrum2

Confirm
Are you sure you want to perform this action?
Performing the operation "Modify WorkItem type 'Bug' in process template 'Scrum2'; delete state" on target "postponed".
[Y] Yes [A] Yes to All [N] No [L] No to All [S] Suspend [?] Help (default is "Yes"): y
```

This removes the state "Postponed" from the WorkItem type "Bug" in the template named "Scrum2" - because -Force was not specified a confirmation prompt is shown.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamWorkItemState -WorkItemType Bug  -ProcessTemplate Scrum2 | Where-Object customizationType -eq "custom" | Remove-VSTeamWorkItemState -Force

```

As an alternative to the first example, this removes any and all custom types from the WorkItem type "Bug" in the template named "Scrum2", and -Force is use to remove any prompt which might appear.

## PARAMETERS

### -Name

Name for the state to be removed.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ProcessTemplate

Specifies the process template where the WorkItem Type to be modified is found; by default this will be the template for the current project. Because only custom templates can contain WorkItem types with custom values, this must be a custom template. Values for this parameter should tab-complete.

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

The name of the WorkItem type whose state list is to be modified. Values for this parameter should tab-complete.

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
