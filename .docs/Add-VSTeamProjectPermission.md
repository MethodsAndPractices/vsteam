<!-- #include "./common/header.md" -->

# Add-VSTeamProjectPermission

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamProjectPermission.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamProjectPermission.md" -->

## EXAMPLES

## PARAMETERS

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
Type: VSTeamProjectPermissions
Required: True
```

### Deny

Deny permissions to add.

```yaml
Type: VSTeamProjectPermissions
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
