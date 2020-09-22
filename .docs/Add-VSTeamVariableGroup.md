<!-- #include "./common/header.md" -->

# Add-VSTeamVariableGroup

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamVariableGroup.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamVariableGroup.md" -->

## EXAMPLES

### Example 1

```powershell
$methodParameters = @{
   ProjectName              = "some_project_name"
   Name        = "new_variable_group"
   Description = "Describe the Variable Group"
   Type        = "Vsts"
   Variables   = @{
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

### Example 2

```powershell
$methodParameters = @{
   ProjectName              = "some_project_name"
   Name        = "new_variable_group"
   Description = "Describe the Variable Group"
   Type        = "AzureKeyVault"
   Variables   = @{
      name_of_existing_secret  = @{
         enabled     = $true
         contentType = ""
         value       = ""
         isSecret    = $true
      }
   }
   ProviderData =  @{
      serviceEndpointId = "AzureRMServiceEndpointGuid"
      vault             = "name_of_existing_key_vault"
   }
}

Add-VSTeamVariableGroup @methodParameters
```

### Example 3

```powershell
# Copy variable group varGroupName from project sourceProjectName to project targetProjectName.  If varGroupName already exists, we'll update it; else, we'll add it.

$Name = "varGroupName"
$FromProject  = "sourceProjectName"
$ToProject = "targetProjectName"

$FromVariableGroupObject = Get-VSTeamVariableGroup -Name $Name -ProjectName $FromProject
$body = ConvertTo-Json -InputObject $FromVariableGroupObject -Depth 100 -Compress
$toVariableGroupObject = Get-VSTeamVariableGroup -Name $Name -ProjectName $ToProject
if ($toVariableGroupObject) {
   Update-VSTeamVariableGroup -Body $body -ProjectName $ToProject -Id $toVariableGroupObject.id
}
else {
   Add-VSTeamVariableGroup -Body $body -ProjectName $ToProject
}

```

## PARAMETERS

### Description

The variable group description

```yaml
Type: String
Parameter Sets: ByHashtable
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### Name

The variable group name

```yaml
Type: String
Parameter Sets: ByHashtable
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### ProviderData

The variable group ProviderData.  This parameter is not available in TFS2017. This should be $null for Vsts types.

```yaml
Type: Hashtable
Parameter Sets: ByHashtable
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### Type

The variable group type.  This parameter is not available in TFS2017; all variable groups are type Vsts in this case.

```yaml
Type: String
Parameter Sets: ByHashtable
Aliases:
Accepted values: Vsts, AzureKeyVault

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### Variables

The variable group variables.

```yaml
Type: Hashtable
Parameter Sets: ByHashtable
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### Body

The json that represents the variable group as a string

```yaml
Type: String
Parameter Sets: ByBody
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

<!-- #include "./params/projectName.md" -->

## INPUTS

### System.String

System.Collections.Hashtable

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Update-VSTeamVariableGroup](Update-VSTeamVariableGroup.md)

[Get-VSTeamVariableGroup](Get-VSTeamVariableGroup.md)

[Remove-VSTeamVariableGroup](Remove-VSTeamVariableGroup.md)
