<!-- #include "./common/header.md" -->

# Add-VSTeamWorkItemIterationPermission

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamWorkItemIterationPermission.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamWorkItemIterationPermission.md" -->

## EXAMPLES

## PARAMETERS

### IterationID

Iteration ID for which the permissions are to be set.

```yaml
Type: Int32
Required: True
```

### IterationPath

Iteration path for which the permissions are to be set.

```yaml
Type: String
Required: True
```

### Descriptor

Descriptor of the user or group to add permissions for.

```yaml
Type: String
Required: True
```

### User

User descriptor to add permissions for.

```yaml
Type: VSTeamUser
Required: True
```

### Group

Group descriptor to add permissions for.

```yaml
Type: VSTeamGroup
Required: True
```

### Allow

Allow permissions to add.

```yaml
Type: VSTeamWorkItemIterationPermissions
Required: True
```

### Deny

Deny permissions to add.

```yaml
Type: VSTeamWorkItemIterationPermissions
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
