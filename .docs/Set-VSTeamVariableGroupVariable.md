<!-- #include "./common/header.md" -->

# Set-VSTeamVariableGroupVariable

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamVariableGroupVariable.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Set-VSTeamVariableGroupVariable.md" -->

## EXAMPLES

### Example 1

```powershell

# In project MyProject, variable group MyVarGroup, set the value of Foo to Hello. The variable
# called Foo will be created if it doesn't already exist.

Set-VSTeamVariableGroupVariable -ProjectName MyProject -GroupName MyVarGroup -Name Foo -Value Hello
```

## PARAMETERS

### GroupName

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

### Name

Name of the variable to set

```yaml
Type: String
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### Value

The new value of the variable

```yaml
Type: String
Aliases:

Required: False
Position: Named
Default value: ""
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

## NOTES

Secret variable updating or creation is not currently supported.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Add-VSTeamVariableGroup](Add-VSTeamVariableGroup.md)

[Get-VSTeamVariableGroup](Get-VSTeamVariableGroup.md)

[Remove-VSTeamVariableGroup](Remove-VSTeamVariableGroup.md)

[Update-VSTeamVariableGroup](Update-VSTeamVariableGroup.md)
