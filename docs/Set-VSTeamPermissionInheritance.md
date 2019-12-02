


# Set-VSTeamPermissionInheritance

## SYNOPSIS

Sets inheritance status of specified resource.

## SYNTAX

## DESCRIPTION

Sets specified ACEs in the ACL for the provided token. 

## EXAMPLES
### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Set-VSTeamPermissionInheritance -resourceName "RepositoryName" -resourceType "Repository" -newState $true -confirm:$false
```

Sets permission inheritance to true for the specified repository, while not requiring direct confirmation the change.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Set-VSTeamPermissionInheritance -resourceName "RepositoryName" -resourceType "Repository" -newState $false -confirm:$false
```

Sets permission inheritance to false for the specified repository, while not requiring direct confirmation the change.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Set-VSTeamPermissionInheritance -resourceName "Build-Name" -resourceType "BuildDefinition" -newState $true 
```

Sets permission inheritance to true for the specified build defintiion, while requiring direct confirmation of the change.

### -------------------------- EXAMPLE 4 --------------------------

```PowerShell
PS C:\> Set-VSTeamPermissionInheritance -resourceName "Build-Name" -resourceType "BuildDefinition" -newState $false
```

Sets permission inheritance to false for the specified build definition, while requiring direct confirmation of the change.

## PARAMETERS

### -resourceName

The name of the resource being set.

```yaml
Type: String
Required: True
```

### -resourceType

The type of resource being set.

Valid types are:

- Repository
- BuildDefinition
- ReleaseDefinition

```yaml
Type: String
Required: True
```

### -newState

The state to change permission inheritance to.

Supported values:
True
False

```yaml
Type: String
Required: True
```

## INPUTS

## OUTPUTS

## NOTES

### This function uses a non-documented REST API to perform the Set operation against repositories, build, and release definitions. The API being utilized was sniffed from performing actions via the web UI and may be documented at some point in the future.

### May not work against TFS and/or on-prem AzD Server.

## RELATED LINKS

