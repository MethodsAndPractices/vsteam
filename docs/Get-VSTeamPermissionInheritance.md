


# Get-VSTeamPermissionInheritance

## SYNOPSIS

Returns true or false.

## SYNTAX

## DESCRIPTION

Returns true or false.

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

