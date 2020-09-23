<!-- #include "./common/header.md" -->

# Set-VSTeamPermissionInheritance

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamPermissionInheritance.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Set-VSTeamPermissionInheritance.md" -->

## EXAMPLES

### Example 1

```powershell
Set-VSTeamPermissionInheritance -ProjectName Demo -Name Demo-CI -ResourceType BuildDefinition -NewState $true -Force
```

This command sets the permission inheritance to true.

### Example 2

```powershell
Get-VSTeamBuildDefinition | Set-VSTeamPermissionInheritance -ResourceType BuildDefinition -NewState $true -Force
```

This command sets the permission inheritance to true for every build definition returned from Get-VSTeamBuildDefinition.

## PARAMETERS

### Name

Specifies the name of the resource.

```yaml
Type: String
Accept pipeline input: true (ByPropertyName)
Required: True
```

### ResourceType

Specifies the type of resource. The acceptable values for this parameter are:

- Repository
- BuildDefinition
- ReleaseDefinition

```yaml
Type: String
Required: True
```

### NewState

The new state to set

```yaml
Type: Boolean
Required: True
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamPolicy](Add-VSTeamPolicy.md)

[Remove-VSTeamPolicy](Remove-VSTeamPolicy.md)

[Set-VSTeamPermissionInheritanceType](Set-VSTeamPermissionInheritanceType.md)
