<!-- #include "./common/header.md" -->

# Get-VSTeamVariableGroup

## SYNOPSIS
<!-- #include "./synopsis/Get-VSTeamVariableGroup.md" -->

## SYNTAX

### List (Default)
```powershell
Get-VSTeamVariableGroup [-ProjectName] <String> [<CommonParameters>]
```

### ByID
```powershell
Get-VSTeamVariableGroup -id <String> [-ProjectName] <String> [<CommonParameters>]
```

## DESCRIPTION
<!-- #include "./synopsis/Get-VSTeamVariableGroup.md" -->
## EXAMPLES

### Example 1

## PARAMETERS

### -ProjectName
The name of the project. 
You can tab complete from the projects in your Team Services or TFS account when passed on the command line.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -id
ID of the existing variable group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String


## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Add-VSTeamVariableGroup](Add-VSTeamVariableGroup.md)

[Update-VSTeamVariableGroup](Update-VSTeamVariableGroup.md)

[Remove-VSTeamVariableGroup](Remove-VSTeamVariableGroup.md)