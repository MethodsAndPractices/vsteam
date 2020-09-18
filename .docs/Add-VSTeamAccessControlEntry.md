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

Security namespace object.

```yaml
Type: vsteam_lib.SecurityNamespace
Parameter Sets: ByNamespace
Required: True
```

### -SecurityNamespaceId

Security namespace identifier.

```yaml
Type: String
Parameter Sets: ByNamespaceId
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

### vsteam_lib.AccessControlEntry

## NOTES

This is a low-level function. You should really use a high level function (Add-VSTeam...Permission / Set-VSTeam...Permission / Get-VSTeam...Permission) unless you know what you are doing.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
