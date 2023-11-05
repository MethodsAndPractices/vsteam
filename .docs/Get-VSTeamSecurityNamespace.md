<!-- #include "./common/header.md" -->

# Get-VSTeamSecurityNamespace

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamSecurityNamespace.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamSecurityNamespace.md" -->

## EXAMPLES

### Example 1
```powershell
Get-VSTeamSecurityNamespace
```

Returns a list of all security namespaces.

### Example 2
```powershell
Get-VSTeamSecurityNamespace -Id "abcdef12-1234-5678-9abc-def123456789"
```

Returns the security namespace with the specified `Id`.

### Example 3
```powershell
Get-VSTeamSecurityNamespace -Name "Project"
```

Returns the security namespace with the name "Project".

### Example 4
```powershell
Get-VSTeamSecurityNamespace -LocalOnly
```

Returns only the local security namespaces.

## PARAMETERS

### Id

Security namespace identifier.

```yaml
Type: String
Required: False
Parameter Sets: ByNamespaceId
```

### Name

Security namespace name.

```yaml
Type: String
Required: False
Parameter Sets: ByNamespaceName
```

### LocalOnly

If true, retrieve only local security namespaces.

```yaml
Type: Switch
Required: False
Parameter Sets: List
```

## INPUTS

## OUTPUTS

### vsteam_lib.SecurityNamespace

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
