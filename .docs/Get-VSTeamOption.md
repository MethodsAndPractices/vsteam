<!-- #include "./common/header.md" -->

# Get-VSTeamOption

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamOption.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamOption.md" -->

There are two table formats defined for the vsteam_lib.Option type, Default and Versions.

Default view contains Name, Area, Max Version and URI Template.

Version view contains Name, Area, Min Version, Max Version, Released Version and Resource Version.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamOption
```

This will display all the versions of supported APIs for your account using the 'Default' table format.

### Example 2

```powershell
Get-VSTeamOption | Format-Table -View Versions
```

This will display all the versions of supported APIs for your account using the 'Versions' custom table format.

### Example 3

```powershell
Get-VSTeamOption -SubDomain vsrm
```

This will display all the versions of supported APIs for the release management service.

### Example 4

```powershell
Get-VSTeamOption -Area core
```

This will display all the versions of supported APIs for the area core.

### Example 5

```powershell
Get-VSTeamOption -Area core -Resource teams
```

This will display all the versions of supported APIs for resources teams under the area core.

## PARAMETERS

### SubDomain

Returns options for that sub domain APIs. Some examples include:

- vsaex = Member Entitlement Management
- feeds = Artifacts
- vsrm = Release Management
- vssps = Graph
- extmgmt = Extensions

```yaml
Type: String
Required: false
```

### Area

Returns options for that area's APIs.

```yaml
Type: String
Required: false
```

### Resource

Returns options for that resource's APIs.

```yaml
Type: String
Required: false
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
