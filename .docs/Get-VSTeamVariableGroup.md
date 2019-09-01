<!-- #include "./common/header.md" -->

# Get-VSTeamVariableGroup

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamVariableGroup.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamVariableGroup.md" -->

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```powershell

$methodParameters = @{
   ProjectName = "some_project_name"
}

Get-VSTeamVariableGroup @methodParameters
```

### -------------------------- EXAMPLE 2 --------------------------

```powershell

$methodParameters = @{
   ProjectName = "some_project_name"
   Id          = "variable_group_id"
}

Get-VSTeamVariableGroup @methodParameters
```

### -------------------------- EXAMPLE 3 --------------------------

```powershell

$methodParameters = @{
   ProjectName = "some_project_name"
   Name        = "variable_group_name"
}

Get-VSTeamVariableGroup @methodParameters
```

## PARAMETERS

### -ProjectName

<!-- #include "./params/projectName.md" -->

### -Id

ID of the existing variable group

### -Name

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
