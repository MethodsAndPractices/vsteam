<!-- #include "./common/header.md" -->

# Add-VSTeamVariableGroup

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamVariableGroup.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamVariableGroup.md" -->

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```powershell

$methodParameters = @{
   ProjectName              = "some_project_name"
   variableGroupName        = "new_variable_group"
   variableGroupDescription = "Describe the Variable Group"
   variableGroupType        = "Vsts"
   variableGroupVariables   = @{
      key1 = @{
         value = "value1"
      }
      key2 = @{
         value    = "value2"
         isSecret = $true
      }
   }
}

Add-VSTeamVariableGroup @methodParameters
```

### -------------------------- EXAMPLE 2 --------------------------

```powershell

$methodParameters = @{
   ProjectName              = "some_project_name"
   variableGroupName        = "new_variable_group"
   variableGroupDescription = "Describe the Variable Group"
   variableGroupType        = "AzureKeyVault"
   variableGroupVariables   = @{
      name_of_existing_secret  = @{
         enabled     = $true
         contentType = ""
         value       = ""
         isSecret    = $true
      }
   }
   variableGroupProviderData =  @{
      serviceEndpointId = "AzureRMServiceEndpointGuid"
      vault             = "name_of_existing_key_vault"
   }
}

Add-VSTeamVariableGroup @methodParameters
```

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -variableGroupDescription

The variable group description

```yaml
Type: String
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
Aliases:
Accepted values: Vsts, AzureKeyVault

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -variableGroupVariables

The variable group variables.

```yaml
Type: Hashtable
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
