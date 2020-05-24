


# Get-VSTeamAPIVersion

## SYNOPSIS

Returns the versions of APIs used.

## SYNTAX

## DESCRIPTION

Returns the versions of APIs used.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamAPIVersion
```

This command gets the API versions currently in use.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamAPIVersion -Service Release
```

This command gets the version of the Release API currently in use.

## PARAMETERS

### -Service

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

## RELATED LINKS

