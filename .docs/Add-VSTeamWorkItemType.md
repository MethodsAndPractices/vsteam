<!-- #include "./common/header.md" -->

# Add-VSTeamWorkItemType

## SYNOPSIS
<!-- #include "./synopsis/Set-VSTeamWorkItemType.md" -->

## SYNTAX

```
Add-VSTeamWorkItemType [[-ProcessTemplate] <Object>] [-WorkItemType] <String> [[-Description] <String>]
 [[-Color] <Object>] [[-Icon] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Adds a new  workitem type to a custom process. Note that the built-in Process templates (Scrum, Agile etc.) do not allow their workitem types to be customized, this is only allowed for custom processes 

## EXAMPLES

### Example 1
```powershell
Add-VSTeamWorkItemType  -ProcessTemplate Scrum5 -WorkItemType ChangeRequest  -Description "New Work item Type" -Color Red  -Icon icon_asterisk 
```
Modifies the custom process "Scrum5", creating a user-defined workitem type "ChangeRequest" with a red asterisk as its icon and some simple text in the description. 

## PARAMETERS

### -Color
Sets the the icon color. The input value can be the name of a color name like "Red" or "Aqua" or 
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
Prompts you for confirmation before running the cmdlet. (By default new types are added without confirmation)

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
Position: 2
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
Position: 4
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
The name for the new workitem type.

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

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS