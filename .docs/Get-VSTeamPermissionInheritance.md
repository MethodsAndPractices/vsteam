<!-- #include "./common/header.md" -->

# Get-VSTeamPermissionInheritance

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamPermissionInheritance.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamPermissionInheritance.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamPermissionInheritance -ProjectName Demo -Name Demo-CI -ResourceType BuildDefinition
```

This command returns true or false.

### Example 2

```powershell
Get-VSTeamBuildDefinition | Get-VSTeamPermissionInheritance
```

This command returns true or false for every build definition returned from Get-VSTeamBuildDefinition.

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

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamPolicy](Add-VSTeamPolicy.md)

[Remove-VSTeamPolicy](Remove-VSTeamPolicy.md)

[Get-VSTeamPermissionInheritanceType](Get-VSTeamPermissionInheritanceType.md)
