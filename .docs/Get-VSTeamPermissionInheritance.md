<!-- #include "./common/header.md" -->

# Get-VSTeamPermissionInheritance

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamPermissionInheritance.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamPermissionInheritance.md" -->

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamPermissionInheritance -ProjectName Demo -Name Demo-CI -ResourceType BuildDefinition
```

This command returns true or false.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuildDefinition | Get-VSTeamPermissionInheritance -ResourceType BuildDefinition
```

This command returns true or false for every build definition returned from Get-VSTeamBuildDefinition.

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamPolicy](Add-VSTeamPolicy.md)

[Remove-VSTeamPolicy](Remove-VSTeamPolicy.md)

[Get-VSTeamPermissionInheritanceType](Get-VSTeamPermissionInheritanceType.md)
