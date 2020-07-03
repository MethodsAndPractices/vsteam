<!-- #include "./common/header.md" -->

# Set-VSTeamWorkItemType

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamWorkItemType.md" -->

## SYNTAX

### LeaveAlone (Default)
```
Set-VSTeamWorkItemType [-ProcessTemplate <Object>] [-WorkItemType] <Object> [-Description <String>]
 [-Color <Object>] [-Icon <String>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Hide
```
Set-VSTeamWorkItemType [-ProcessTemplate <Object>] [-WorkItemType] <Object> [-Description <String>]
 [-Color <Object>] [-Icon <String>] [-Disabled] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Show
```
Set-VSTeamWorkItemType [-ProcessTemplate <Object>] [-WorkItemType] <Object> [-Description <String>]
 [-Color <Object>] [-Icon <String>] [-Enabled] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Modifies an existing workitem type in a custom process; where the workitem type is a built-in type, like "bug", 
the orginal item is preserved and a new inherited version is created. 
It is possible to change the Description, Icon, Icon Color, and to enable or disable the workitem type



## EXAMPLES

### Example 1
```powershell
Set-VSTeamWorkItemType -ProcessTemplate Scrum5 -WorkItemType Impediment -Disabled
```

Modifies the custom process "Scrum5", disabling the built in workitem type "Impediment".

### Example 2
```powershell
Set-VSTeamWorkItemType -ProcessTemplate Scrum5 -WorkItemType ChangeRequest -Icon icon_parachute -color Blue -Description "For requests from customers"  
```

Modifies the custom process "Scrum5", changing a user-defined workitem type "ChangeRequest" to use 
a blue parachute icon and update its description.

## PARAMETERS

### -Color
Changes the the icon color. The input value can be the name of a color name like "Red" or "Aqua" or 
a hex value for red, green and blue parts. Color names should tab complete.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -Description
Long text description of the the workitem type.

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

### -Disabled
If specified, disables the workitem so that it can not be selected for new items. 

```yaml
Type: SwitchParameter
Parameter Sets: Hide
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled
If specified, enables a workitem which was previously disabled.

```yaml
Type: SwitchParameter
Parameter Sets: Show
Aliases:

Required: True
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

### -Icon
One of the predefined icons for workitem types. Possible values should tab complete and 
if the name omits the leading "Icon_" it will be added automatically. 

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

### -ProcessTemplate
The process template to modify. Note that the built-in templates ("Scrum", "Agile" etc.) cannot be modified,
only custom templates (derived from the built-in ones) can be changed. 

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
The name of the workitem type to be modified. 

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Name

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
