<!-- #include "./common/header.md" -->

# Get-VSTeamAPIVersion

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamAPIVersion.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamAPIVersion.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamAPIVersion
```

This command gets the API versions currently in use.

### Example 2

```powershell
Get-VSTeamAPIVersion -Service Release
```

This command gets the version of the Release API currently in use.

## PARAMETERS

### Service

Specifies the service to change. The acceptable values for this parameter are:

- Build
- Release
- Core
- Git
- DistributedTask
- Tfvc
- Packaging
- MemberEntitlementManagement
- ExtensionsManagement
- ServiceEndpoints

```yaml
Type: String
Required: True
Parameter Sets: Service
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
