<!-- #include "./common/header.md" -->

# Remove-VSTeamVariableGroup

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamVariableGroup.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamVariableGroup.md" -->

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
   Force                    = $true
}

Remove-VSTeamVariableGroup @methodParameters
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

<!-- #include "./params/projectName.md" -->

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Add-VSTeamVariableGroup](Add-VSTeamVariableGroup.md)

[Get-VSTeamVariableGroup](Get-VSTeamVariableGroup.md)

[Update-VSTeamVariableGroup](Update-VSTeamVariableGroup.md)
