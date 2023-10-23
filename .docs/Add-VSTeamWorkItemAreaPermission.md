<!-- #include "./common/header.md" -->

# Add-VSTeamWorkItemAreaPermission

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamWorkItemAreaPermission.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamWorkItemAreaPermission.md" -->

## EXAMPLES

## PARAMETERS

### AreaID

Area ID of the work item area for which the permissions are to be set.

```yaml
Type: Int32
Required: True
```

### AreaPath

Area path of the work item area for which the permissions are to be set.

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
Type: VSTeamWorkItemAreaPermissions
Required: True
```

### Deny

Deny permissions to add.

```yaml
Type: VSTeamWorkItemAreaPermissions
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
