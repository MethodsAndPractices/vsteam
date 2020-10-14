<!-- #include "./common/header.md" -->

# Get-VSTeamField

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamField.md -->

## SYNTAX

## DESCRIPTION
The definition of every WorkItem type in every process definition uses a set of datafields from a shared set of fields available across the organization. This command returns those fields, showing their name and reference name, type, description and othere properties.  

## EXAMPLES

### Example 1
```powershell
Get-VSTeamField
```

Returns a complete list of fields defined for the organization. 

### Example 1
```powershell
Get-VSTeamField -Name tags
```

Returns the System.Tags field. Note the commands which work with fields will resolve short names like Tags, to their reference names (System.Tags in this case) but do not support wildcards (System.Ta* will result in an error)


## PARAMETERS

### -ReferenceName
The fully qualified or partial reference name. Note that display names like "Target Date" which contain a space may have a reference name in the form "Microsoft.VSTS.Scheduling.TargetDate" the resolution of the partial name looks for the section after the final "." character, which is "TargetDate" with no space, and not the same as the display name. 

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
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
[Get-VsteamWorkItemField](Get-VsteamWorkItemField.md)

[Add-VSTeamField](Add-VSTeamField.md)
