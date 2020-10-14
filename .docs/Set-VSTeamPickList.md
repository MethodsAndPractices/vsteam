<!-- #include "./common/header.md" -->

# Set-VSTeamPickList

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamPickList.md" -->

## SYNTAX

## DESCRIPTION
Modifies an existing picklist, so that fields can be offered different selections. The list can either be cleared or added to 

## EXAMPLES

### Example 1
```powershell
Set-VSTeamPickList --PicklistID Offices -RemoveOldItems -NewItems  "New York", "London",  "Munich"  -Force

Name    Type   Suggested Items
----    ----   --------- -----
Offices String False     New York, London, Munich

```

In this example the existing list of offices is reset to the three listed. Note the items only need to be enclosed in quotes where they contain spaces or punctuation


### Example 2
```powershell
Set-VSTeamPickList -PicklistID Office   -NewItems  "Tokyo"  -Force  

Name   Type   Suggested Items
----   ----   --------- -----
Office String False     New York, London, Munich, Tokyo

```

In this example the "Tokyo" is added to the existing list.


## PARAMETERS
<!-- #include "./params/forcegroup.md" -->

### -IsSuggested
Changes the "Options are suggestions" / "Selection from the list is mandatory" setting for the picklist. To remove the "Is Suggested" flag when it has been set use -IsSuggested:$false

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

### -NewItems
The items to add to the list (if -RemoveOldItems is not specified) or be the whole of the list (if it is specified)

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PicklistID
The name or guid of the picklist Name can be used as an alias. 

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Name, ID

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -RemoveOldItems
Unless specified new items will be added to the existing ones; if specified the existing items will be removed and the list will only contain the new items.  

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

### -Type
Changes the type of the picklist. Only used if the list was orginally numbers and needs to contain strings, or if type was not specified when the list was created and so it is treating numbers as a strings  

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: double, integer, string

Required: False
Position: Named
Default value: None
Accept pipeline input: False
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

[Add-VSTeamPickList](Add-VSTeamPickList.md)

[Get-VSTeamPickList](Get-VSTeamPickList.md)
