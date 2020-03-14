


# Remove-VSTeamVariableGroup

## SYNOPSIS

Removes a variable group

## SYNTAX

## DESCRIPTION

Removes a variable group

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```powershell

$methodParameters = @{
   ProjectName              = "some_project_name"
   Name        = "new_variable_group"
   Description = "Describe the Variable Group"
   Type        = "Vsts"
   Variables   = @{
      key1 = @{
         value = "value1"
         isSecret = $true
      }
   }
}

$newVariableGroup = Add-VSTeamVariableGroup @methodParameters

$methodParameters = @{
   Id                       = $newVariableGroup.id
   ProjectName              = "some_project_name"
   Force                    = $true
}

Remove-VSTeamVariableGroup @methodParameters
```

## PARAMETERS

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

### -Force

Forces the function without confirmation

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
```

### -Confirm

Prompts you for confirmation before running the function.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
Aliases: cf
```

### -WhatIf

Shows what would happen if the function runs.
The function is not run.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
Aliases: wi
```

### -Id

ID of the existing variable group

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

### System.String[]

System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Add-VSTeamVariableGroup](Add-VSTeamVariableGroup.md)

[Get-VSTeamVariableGroup](Get-VSTeamVariableGroup.md)

[Update-VSTeamVariableGroup](Update-VSTeamVariableGroup.md)

