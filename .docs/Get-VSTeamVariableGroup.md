<!-- #include "./common/header.md" -->

# Get-VSTeamVariableGroup

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamVariableGroup.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamVariableGroup.md" -->

## EXAMPLES

### Example 1

```powershell
$methodParameters = @{
   ProjectName = "some_project_name"
}

Get-VSTeamVariableGroup @methodParameters
```

### Example 2

```powershell
$methodParameters = @{
   ProjectName = "some_project_name"
   Id          = "variable_group_id"
}

Get-VSTeamVariableGroup @methodParameters
```

### Example 3

```powershell
$methodParameters = @{
   ProjectName = "some_project_name"
   Name        = "variable_group_name"
}

Get-VSTeamVariableGroup @methodParameters
```

## PARAMETERS

### Id

ID of the existing variable group

```yaml
Type: String
Required: false
```

### Name

Name of the existing variable group

```yaml
Type: String
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

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamVariableGroup](Add-VSTeamVariableGroup.md)

[Update-VSTeamVariableGroup](Update-VSTeamVariableGroup.md)

[Remove-VSTeamVariableGroup](Remove-VSTeamVariableGroup.md)
