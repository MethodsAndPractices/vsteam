<!-- #include "./common/header.md" -->

# Get-VSTeamDescriptor

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamDescriptor.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamDescriptor.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamDescriptor -StorageKey "a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6"
```

This command retrieves the descriptor associated with the provided storage key.

### Example 2

```powershell
"a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6" | Get-VSTeamDescriptor
```

This example demonstrates how to pipe a storage key string directly to `Get-VSTeamDescriptor` to obtain the corresponding descriptor.

## PARAMETERS

### StorageKey

Storage key of the subject (user, group, scope, etc.) to resolve

```yaml
Type: String
Required: True
Position: 0
Parameter Sets: ByStorageKey
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
