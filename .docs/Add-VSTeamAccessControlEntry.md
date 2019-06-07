<!-- #include "./common/header.md" -->

# Add-VSTeamAccessControlEntry

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamAccessControlEntry.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamAccessControlEntry.md" -->

## EXAMPLES

## PARAMETERS

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/SecurityNamespaceName.md" -->

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

The security Token

```yaml
Type: String
Required: True
```

### -AllowMask

Bitmask for Allow Permissions

```yaml
Type: Int
Required: True
```

### -DenyMask

Bitmask for Deny Permissions

```yaml
Type: Int
Required: True
```

## INPUTS

## OUTPUTS

### VSTeamAccessControlEntry

## NOTES

## RELATED LINKS
