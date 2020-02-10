


# Set-VSTeamPermissionInheritance

## SYNOPSIS

Sets the permission inheritance to true or false.

## SYNTAX

## DESCRIPTION

Sets the permission inheritance to true or false.

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

### -NewState

The new state to set

```yaml
Type: Boolean
Required: True
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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamPolicy](Add-VSTeamPolicy.md)

[Remove-VSTeamPolicy](Remove-VSTeamPolicy.md)

[Set-VSTeamPermissionInheritanceType](Set-VSTeamPermissionInheritanceType.md)

