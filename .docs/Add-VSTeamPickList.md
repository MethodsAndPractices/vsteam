<!-- #include "./common/header.md" -->

# Add-VSTeamPickList

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamPickList.md" -->

## SYNTAX

## DESCRIPTION

String and integer fields used in the definition of types of WorkItems can use picklists to supply values. The user may be limited to only the items in the list or the list may be suggestions allowing the user to enter a different value. This command adds a list which may then be used in multiple fields if required.  

## EXAMPLES

### Example 1
```powershell
Add-VSTeamPickList -Name Offices -Items "New York", "London", "Paris", "Munich"

Name    Type   Suggested Items
----    ----   --------- -----
Offices String False     New York, London, Paris, Munich
```

Creates a Picklist to suggest locations. Note the items only need to be enclosed in quotes where they contain spaces or punctuation. In this case the type has been left as string, and the choice is manadatory (not suggested).

## PARAMETERS

<!-- #include "./params/forcegroup.md" -->

### -IsSuggested
By default the selection for a control using a picklist must be a value from the list. If IsSuggested is set then other values my be entered.

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

### -Items
A comma seperated list of items, or variable containing the items to offer on the list.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
A name for the Picklist, this name will only be used to link the list to one or more fields - the user interface only shows the field names.

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

### -Type
String by default, or integer if the values are for integer fields.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values:  integer, string

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

[Get-VSTeamPickList](Get-VSTeamPickList.md)

[Set-VSTeamPickList](Set-VSTeamPickList.md)

[Add-VSTeamField](Add-VSTeamField.md)
