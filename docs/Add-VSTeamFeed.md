


# Add-VSTeamFeed

## SYNOPSIS

Adds a new feed to package management.

## SYNTAX

## DESCRIPTION

Adds a new feed to package management.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Add-VSTeamFeed -Name test -Description 'Test Description'
```

This command adds a new package feed to the account.

## PARAMETERS

### -Name

Name of the feed

```yaml
Type: string
Accept pipeline input: true (ByPropertyName)
```

### -Description

Description of the feed

```yaml
Type: string
```

### -EnableUpstreamSources

Enables npm and nuget upstream sources for the feed

```yaml
Type: SwitchParameter
```

### -showDeletedPackageVersions

The feed will show deleted version in the feed

```yaml
Type: SwitchParameter
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

