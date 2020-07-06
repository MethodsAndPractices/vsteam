<!-- #include "./common/header.md" -->

# Remove-VSTeamWorkItemType

## SYNOPSIS
<!-- #include "./synopsis/Remove-VSTeamWorkItemType.md" -->

## SYNTAX

```
Remove-VSTeamWorkItemType [-ProcessTemplate] <Object> [-WorkItemType] <Object> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Removes a custom workitem type, or reverts an inherited workitem type back to the built-in Type. 
If the type is a system type (as all workitem types in built-in Process templates are) then an error will be thrown. 
These types can can be disabled (in custom process templates) using Set-VSTeamWorkItemType -Disable

## EXAMPLES

### Example 1
```powershell
Remove-VSTeamWorkItemType -ProcessTemplate Scrum5 -WorkItemType ChangeRequest 
```

Modifies the custom process "Scrum5", removing the user-defined workitem type "ChangeRequest"

## PARAMETERS

### -Confirm
Prompts you for confirmation before running the cmdlet. Normally the command will prompt for confirmation and -Confirm is only needed if $ConfirmPreference has been changed.

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
Normally the command will prompt for confirmation -Force supresses the prompt.

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

### -ProcessTemplate
The process template to modify. Note that the built-in templates ("Scrum", "Agile" etc.) cannot be modified,
only custom templates (derived from the built-in ones) can be changed. 

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
The name of the workitem type to be removed or reverted. If the WorkItem type is a system type 
(for example if had been chaged but has already been reverted), then an error will be thrown. 
The built-in system types cannot be deleted, but can be disabled with Set-VSTeamWorkItemType.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Name

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