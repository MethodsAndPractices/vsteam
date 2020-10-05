<!-- #include "./common/header.md" -->

# Set-VSTeamWorkItemType

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamWorkItemType.md" -->

## SYNTAX

## Description

Modifies an existing work item type in a custom process; where the work item type is a built-in type, like "Bug",
the original item is preserved and a new inherited version is created.
It is possible to change the Description, Icon, Icon Color, and to enable or disable the work item type

## EXAMPLES

### Example 1

```powershell
Set-VSTeamWorkItemType -ProcessTemplate Scrum5 -WorkItemType Impediment -Disabled
```

Modifies the custom process "Scrum5", disabling the built in work item type "Impediment".

### Example 2

```powershell
Set-VSTeamWorkItemType -ProcessTemplate Scrum5 -WorkItemType ChangeRequest -Icon icon_parachute -color Blue -Description "For requests from customers"
```

Modifies the custom process "Scrum5", changing a user-defined work item type "ChangeRequest" to use
a blue parachute icon and update its description..
## PARAMETERS

### -Color

Changes the the icon color. The input value can be the name of a color name like "Red" or "Aqua" or
a hex value for red, green and blue parts. Color names should tab complete.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet. Normally the command will prompt for confirmation and -Confirm is only needed if \$ConfirmPreference has been changed.

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

Long text description of the the work item type.

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

### -Disabled

If specified, disables the work item so that it can not be selected for new items.

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

If specified, enables a work item which was previously disabled.

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

<!-- #include "./params/force.md" -->

### -Icon

One of the predefined icons for work item types. Possible values should tab complete and
if the name omits the leading "Icon\_" it will be added automatically.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProcessTemplate

The process template to modify. Note that the built-in templates ("Scrum", "Agile" etc.) cannot be modified, only custom templates (derived from the built-in ones) can be changed.

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

The name of the work item type to be modified.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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
[Add-VSTeamWorkItemType](Add-VSTeamWorkItemType.md)

[Get-VSTeamWorkItemType](Get-VSTeamWorkItemType.md)

[Remove-VSTeamWorkItemType](Remove-VSTeamWorkItemType.md)