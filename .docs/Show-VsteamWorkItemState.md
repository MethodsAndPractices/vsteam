<!-- #include "./common/header.md" -->

# Add-VSTeamWorkItem

## SYNOPSIS

<!-- #include "./synopsis/Show-VsteamWorkItemState.md" -->

## SYNTAX

```
Show-VsteamWorkItemState -ProcessTemplate <Object> -WorkItemType <Object> [-Name] <Object> [-Force] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Each WorkItem type in each process templates has a set of possible states.  Items may have system defined states and/or custom (user defined) states. System states cannot be removed, but can be hidden and this command is used to unhide states which have previously been hidden 

## EXAMPLES

### Example 1
```powershell
PS C:\> Show-VsteamWorkItemState -WorkItemType Bug -Name Approved -ProcessTemplate Scrum2

```
This unhides the "Approved" state for bug in the custom process template "Scrum2". If the state is not hidden a warning message will appear and the state will not be changed. 

## PARAMETERS

### -Confirm
Prompts you for confirmation before running the cmdlet. 

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
Suppresses the confirmation dialog so the command can be run without user intervention. By default SHOW does not require confirmation unless the $ConfirmPreference variable is changed -Force will not be needed. Hide and Show have different behaviors because hiding a state which is needed is considered harmful.


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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
