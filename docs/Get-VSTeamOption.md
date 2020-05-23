


# Get-VSTeamOption

## SYNOPSIS

Returns all the versions of supported APIs of your TFS or AzD.

## SYNTAX

## DESCRIPTION

Returns all the versions of supported APIs of your TFS or AzD.

There are two table formats defined for the Team.Option type, Default and Versions.

Default view contains Name, Area, Max Version and URI Template.

Version view contains Name, Area, Min Version, Max Version, Released Version and Resource Version.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamOption
```

This will display all the versions of supported APIs for your account using the 'Default' table format.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamOption | Format-Table -View Versions
```

This will display all the versions of supported APIs for your account using the 'Versions' custom table format.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Get-VSTeamOption -SubDomain vsrm
```

This will display all the versions of supported APIs for the release management service.

### -------------------------- EXAMPLE 4 --------------------------

```PowerShell
PS C:\> Get-VSTeamOption -Area core
```

This will display all the versions of supported APIs for the area core.

### -------------------------- EXAMPLE 5 --------------------------

```PowerShell
PS C:\> Get-VSTeamOption -Area core -Resource teams
```

This will display all the versions of supported APIs for resources teams under the area core.

## PARAMETERS

### -SubDomain

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

### -Area

Returns options for that area's APIs.

```yaml
Type: String
Required: false
```

### -Resource

Returns options for that resource's APIs.

```yaml
Type: String
Required: false
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

