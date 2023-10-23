<!-- #include "./common/header.md" -->

# Add-VSTeamGitRepositoryPermission

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamGitRepositoryPermission.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamGitRepositoryPermission.md" -->

## EXAMPLES

## PARAMETERS

### RepositoryId

ID of the repository for which the permissions are to be set.

```yaml
Type: String
Required: True
```

### RepositoryName

Name of the repository for which the permissions are to be set.

```yaml
Type: String
Required: True
```

### BranchName

Name of the branch for which the permissions are to be set.

```yaml
Type: String
Required: True
```

### Descriptor

Descriptor of the user or group for which the permissions are to be set.

```yaml
Type: String
Required: True
```

### User

User descriptor for which the permissions are to be set.

```yaml
Type: VSTeamUser
Required: True
```

### Group

Group descriptor for which the permissions are to be set.

```yaml
Type: VSTeamGroup
Required: True
```

### Allow

Allow permissions to be set.

```yaml
Type: VSTeamGitRepositoryPermissions
Required: True
```

### Deny

Deny permissions to be set.

```yaml
Type: VSTeamGitRepositoryPermissions
Required: True
```

### OverwriteMask

Switch to overwrite the mask values rather than merge them.

```yaml
Type: Switch
Required: False
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
