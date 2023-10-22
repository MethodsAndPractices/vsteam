<!-- #include "./common/header.md" -->

# Remove-VSTeamAccessControlList

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamAccessControlList.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamAccessControlList.md" -->

## EXAMPLES

### Example 1
```powershell
$namespace = Get-VSTeamSecurityNamespace -NamespaceId "abcdef12-1234-5678-9abc-def123456789"
Remove-VSTeamAccessControlList -SecurityNamespace $namespace -Tokens "token1,token2"
```

Removes access control lists for the specified tokens "token1" and "token2" from the security namespace retrieved using the provided `NamespaceId`.

### Example 2
```powershell
Remove-VSTeamAccessControlList -SecurityNamespaceId "abcdef12-1234-5678-9abc-def123456789" -Tokens "token1" -Recurse
```

Recursively removes the access control list for the specified token "token1" from the security namespace with the given `SecurityNamespaceId`.

### Example 3
```powershell
Remove-VSTeamAccessControlList -SecurityNamespaceId "abcdef12-1234-5678-9abc-def123456789" -Tokens "token1" -Force
```

Removes the access control list for the specified token "token1" from the security namespace with the given `SecurityNamespaceId` and forces the removal without any confirmation prompts.

### Example 4
```powershell
Remove-VSTeamAccessControlList -SecurityNamespaceId "abcdef12-1234-5678-9abc-def123456789" -Tokens "token1" -Recurse -WhatIf
```

Shows what would happen if the command runs to recursively remove the access control list for the specified token "token1" from the security namespace with the given `SecurityNamespaceId`, without actually executing the command.

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

### Tokens

One or more comma-separated security tokens

```yaml
Type: String
Required: True
```

### Recurse

If true and this is a hierarchical namespace, also remove child ACLs of the specified tokens.

```yaml
Type: Switch
Required: True
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
