


# Get-VSTeamPermissionInheritance

## SYNOPSIS

Retrieves inheritance status of specified resource.

## SYNTAX

## DESCRIPTION

Retrieves specified ACEs in the ACL for the provided token. 

## EXAMPLES
### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamPermissionInheritance -resourceName "RepositoryName" -resourceType "Repository"
```

This will retrieve the permission inheritance status on the named repository.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamPermissionInheritance -resourceName "Build-Name" -resourceType "BuildDefinition"
```

This will retrieve the permission inheritance status on the named build definition.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Get-VSTeamPermissionInheritance -resourceName "Release-Name" -resourceType "ReleaseDefinition"
```

This will retrieve the permission inheritance status on the named release definition.

## PARAMETERS

### -resourceName

The name of the resource being retreived.

```yaml
Type: String
Required: True
```

### -resourceType

The type of resource being retrieved.

Valid types are:

- Repository
- BuildDefinition
- ReleaseDefinition

```

## INPUTS

## OUTPUTS

## NOTES

### This function uses a non-documented REST API to perform the Set operation against repositories, build, and release definitions. The API being utilized was sniffed from performing actions via the web UI and may be documented at some point in the future.

### May not work against TFS and/or on-prem AzD Server.

## RELATED LINKS

