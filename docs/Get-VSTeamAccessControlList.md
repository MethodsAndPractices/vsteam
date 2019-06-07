


# Get-VSTeamAccessControlList

## SYNOPSIS

Return a list of access control lists for the specified security namespace and token. All ACLs in the security namespace will be retrieved if no optional parameters are provided.

## SYNTAX

## DESCRIPTION

Return a list of access control lists for the specified security namespace and token. All ACLs in the security namespace will be retrieved if no optional parameters are provided.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
Get-VSTeamSecurityNamespace | Select-Object -First 1 | Get-VSTeamAccessControlList
```

## PARAMETERS

### -SecurityNamespace

Security namespace identifier.

```yaml
Type: VSTeamSecurityNamespace
Required: True
```

### -SecurityNamespaceId

Security namespace identifier.

```yaml
Type: String
Required: True
```

### -Token

Security token

```yaml
Type: String
Required: True
```

### -Descriptors

An optional filter string containing a list of identity descriptors whose ACEs should be retrieved. If this is not set entire ACLs will be returned.

```yaml
Type: String
Required: True
```

### -IncludeExtendedInfo

If set, populate the extended information properties for the access control entries contained in the returned lists.

```yaml
Type: Switch
Required: True
```

### -Recurse

If true and this is a hierarchical namespace, return child ACLs of the specified token.

```yaml
Type: Switch
Required: True
```

## INPUTS

## OUTPUTS

### VSTeamAccessControlList

## NOTES

## RELATED LINKS

