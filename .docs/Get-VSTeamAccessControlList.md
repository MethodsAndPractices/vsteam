<!-- #include "./common/header.md" -->

# Get-VSTeamAccessControlList

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamAccessControlList.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamAccessControlList.md" -->

## EXAMPLES

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