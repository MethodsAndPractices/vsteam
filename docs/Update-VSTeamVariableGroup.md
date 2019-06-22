


# Update-VSTeamVariableGroup

## SYNOPSIS

Updates an existing variable group

## SYNTAX

## DESCRIPTION

Updates an existing variable group

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
         isSecret = $true
      }
   }
}

$newVariableGroup = Add-VSTeamVariableGroup @methodParameters

$methodParameters = @{
   id                       = $newVariableGroup.id
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

Update-VSTeamVariableGroup @methodParameters
```

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

Does not prompt

```yaml
Type: SwitchParameter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectName

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 0
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id

ID of the existing variable group

```yaml
Type: String
Aliases:

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

[Add-VSTeamVariableGroup](Add-VSTeamVariableGroup.md)

[Get-VSTeamVariableGroup](Get-VSTeamVariableGroup.md)

[Remove-VSTeamVariableGroup](Remove-VSTeamVariableGroup.md)

