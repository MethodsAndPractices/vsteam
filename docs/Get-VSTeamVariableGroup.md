


# Get-VSTeamVariableGroup

## SYNOPSIS

Gets a variable group

## SYNTAX

## DESCRIPTION

Gets a variable group

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

