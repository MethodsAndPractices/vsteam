<!-- #include "./common/header.md" -->

# Get-VsteamWorkItemField

## SYNOPSIS

<!-- #include "./synopsis/Get-VsteamWorkItemField.md" -->

## SYNTAX

## DESCRIPTION
<!-- #include "./synopsis/Get-VsteamWorkItemField.md" -->

## EXAMPLES

### Example 1
```powershell
Get-VSTeamWorkItemfield bug
```

Returns the fields in "Bug" WorkItems in the current project's process template. 


### Example 2
```powershell
Get-VSTeamWorkItemfield -ProcessTemplate Scrum5 --WorkItemType  Change
```

Returns the fields in "Change" WorkItems in the custom process templated named "Scrum5" 

### Example 3
```powershell
Get-VSTeamWorkItemfield * | Group-Object -property Name  -NoElement  | Sort-Object count
```

Gets the fields for all WorkItem types in the current project's template and produces count show how frequently they are used. 

## PARAMETERS

### -ProcessTemplate
The name of the process template holding the WorkItem type(s) of interest

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
The name of the WorkItem type(s) of interest (wildcards are allowed.) 

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
