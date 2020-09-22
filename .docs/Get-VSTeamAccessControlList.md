<!-- #include "./common/header.md" -->

# Get-VSTeamAccessControlList

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamAccessControlList.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamAccessControlList.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamSecurityNamespace | Select-Object -First 1 | Get-VSTeamAccessControlList
```

## PARAMETERS

### SecurityNamespace

Security namespace object.

```yaml
Type: vsteam_lib.SecurityNamespace
Parameter Sets: ByNamespace
Required: True
```

### SecurityNamespaceId

Security namespace identifier.

```yaml
Type: String
Parameter Sets: ByNamespaceId
Required: True
```

### Token

Security token

```yaml
Type: String
Required: True
```

### Descriptors

An optional filter string containing a list of identity descriptors whose ACEs should be retrieved. If this is not set entire ACLs will be returned.

```yaml
Type: String
Required: True
```

### IncludeExtendedInfo

If set, populate the extended information properties for the access control entries contained in the returned lists.

```yaml
Type: Switch
Required: True
```

### Recurse

If true and this is a hierarchical namespace, return child ACLs of the specified token.

```yaml
Type: Switch
Required: True
```

## INPUTS

## OUTPUTS

### vsteam_lib.AccessControlList

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
