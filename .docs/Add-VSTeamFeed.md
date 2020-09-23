<!-- #include "./common/header.md" -->

# Add-VSTeamFeed

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamFeed.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamFeed.md" -->

## EXAMPLES

### Example 1

```powershell
Add-VSTeamFeed -Name test -Description 'Test Description'
```

This command adds a new package feed to the account.

## PARAMETERS

### Name

Name of the feed

```yaml
Type: string
Accept pipeline input: true (ByPropertyName)
```

### Description

Description of the feed

```yaml
Type: string
```

### EnableUpstreamSources

Enables npm and nuget upstream sources for the feed

```yaml
Type: SwitchParameter
```

### showDeletedPackageVersions

The feed will show deleted version in the feed

```yaml
Type: SwitchParameter
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
