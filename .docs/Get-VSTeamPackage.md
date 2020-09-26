<!-- #include "./common/header.md" -->

# Get-VSTeamPackage

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamPackage.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamPackage.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamFeed | Get-VSTeamPackage
```

This command returns all the packages for all the feeds returned by Get-VSTeamFeed.

## PARAMETERS

### FeedId

Specifies the Id of the feed.

```yaml
Type: guid
Position: 0
Required: true
Accept pipeline input: true (ByValue, ByPropertyName)
```

### PackageId

Specifies the Id of the package.

```yaml
Type: guid
Position: 1
Aliases: ID
Accept pipeline input: false
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

[Add-VSTeamFeed](Add-VSTeamFeed.md)

<!-- #include "./common/related.md" -->
