<!-- #include "./common/header.md" -->

# Set-VSTeamPermissionInheritance

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamPermissionInheritance.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Set-VSTeamPermissionInheritance.md" -->

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Set-VSTeamPermissionInheritance -ProjectName Demo -Name Demo-CI -ResourceType BuildDefinition -NewState $true -Force
```

This command sets the permission inheritance to true.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuildDefinition | Set-VSTeamPermissionInheritance -ResourceType BuildDefinition -NewState $true -Force
```

ThisThis command sets the permission inheritance to true for every build definition returned from Get-VSTeamBuildDefinition.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Name

Specifies the name of the resource.

```yaml
Type: String
Accept pipeline input: true (ByPropertyName)
Required: True
```

### -ResourceType

Specifies the type of resource. The acceptable values for this parameter are:

- Repository
- BuildDefinition
- ReleaseDefinition

```yaml
Type: String
Required: True
```

### -NewState

The new state to set

```yaml
Type: Boolean
Required: True
```

<!-- #include "./params/force.md" -->

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamPolicy](Add-VSTeamPolicy.md)

[Remove-VSTeamPolicy](Remove-VSTeamPolicy.md)

[Set-VSTeamPermissionInheritanceType](Set-VSTeamPermissionInheritanceType.md)
