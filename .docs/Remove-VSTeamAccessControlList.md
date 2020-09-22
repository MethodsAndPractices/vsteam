<!-- #include "./common/header.md" -->

# Remove-VSTeamAccessControlList

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamAccessControlList.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamAccessControlList.md" -->

## EXAMPLES

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

## INPUTS

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
