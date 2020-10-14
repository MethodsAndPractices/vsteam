<!-- #include "./common/header.md" -->

# Add-VSTeamField

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamField.md" -->

## SYNTAX

## DESCRIPTION

The definition of every WorkItem type in every process definition uses a set of datafields from a shared set of fields available across the organization. Each field is defined with a name, a description, a datatype, and optionally a picklist of values. This command defines new fields. Note that the API only allows fields to be disabled after they have been created, not to be modified or deleted. 


## EXAMPLES

### Example 1
```powershell
Add-VSTeamField -Name Office -Type string -PicklistID Offices -Description "Business Location"  -force 

Name    Reference Name   Usage    Type   Read Only Description
----    --------------   -----    ----   --------- -----------
Office   Custom.Office   workItem string False    Business Location

```
Creates a new field, with a name, description and the optional picklist option filled in. Normally the command will pause for confirmation but here -Force has been specified.  

## PARAMETERS

<!-- #include "./params/forcegroup.md" -->

### -Description
A description for the data field
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

### -IsPickListSuggested
If a picklist is specified, the input must be a value from the list, unless -IsPickListSuggested is supplied which means options are suggestions but other values may be entered.

```yaml
Type: SwitchParameter
Parameter Sets: WithPickList
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name for the the new field.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoSort
If specified the field will not be configured to allow sorting.

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

### -NotQueryable
If specified the field cannot be the basis of a query.

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

### -PicklistID
Specifies a pre-existing picklist. Depending on the value of -IsPickListSuggested, selecting from the Picklist can be mandatory or optional,

```yaml
Type: Object
Parameter Sets: WithPickList
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReadOnly
If specified does not allow user input.

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

### -ReferenceName
Every field has a qualified reference name in addition to its short name. If this field is not provided it will be set to "Custom.Shortname" 

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

### -Type
The datatype for the new field. This defaults to string, which is a single line of plain text in the user interface; multi-line rich text boxes are HTML, and as well as normal boolean, integer,double, and datetime values, indentity (a box to select a person, simililar to assigned-to) is supported.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: boolean, dateTime, double, html, identity, integer, string

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Usage
Fields may be defined for use in WorkItems, WorkItem links, WorkItem-type extensions, trees or none of the these. The default value is workitem and this should not need to be changed. 

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: workItem, workItemLink, workItemTypeExtension, tree, none

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-VSTeamField](Get-VSTeamField.md)

[Add-VSTeamWorkItemField](Add-VSTeamWorkItemField.md)

[Get-VSTeamPickList](Get-VSTeamPickList.md)
