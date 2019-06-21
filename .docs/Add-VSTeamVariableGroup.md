<!-- #include "./common/header.md" -->

# Add-VSTeamVariableGroup

## SYNOPSIS
<!-- #include "./synopsis/Add-VSTeamServiceEndpoint.md" -->

## SYNTAX

```powershell
Add-VSTeamVariableGroup [-variableGroupName] <String> [-variableGroupType] <String>
 [-variableGroupDescription] <String> [-variableGroupVariables] <Hashtable>
 [[-variableGroupProviderData] <Hashtable>] [-ProjectName] <String> [<CommonParameters>]
```

## DESCRIPTION
<!-- #include "./synopsis/Add-VSTeamServiceEndpoint.md" -->

## EXAMPLES

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

### -variableGroupDescription
The variable group description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -variableGroupName
The variable group name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -variableGroupProviderData
The variable group ProviderData.  This should be $null for Vsts types.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -variableGroupType
The variable group type

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Vsts, AzureKeyVault

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -variableGroupVariables
The variable group variables. Please refer to the unit test for examples.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
System.Collections.Hashtable


## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Update-VSTeamVariableGroup](Update-VSTeamVariableGroup.md)

[Get-VSTeamVariableGroup](Get-VSTeamVariableGroup.md)

[Remove-VSTeamVariableGroup](Remove-VSTeamVariableGroup.md)