<!-- #include "./common/header.md" -->

# Update-VSTeamNuGetPackageVersion

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamNuGetPackageVersion.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamNuGetPackageVersion.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamPackageVersion -feedName ber -packageId 0d64db64-c7b7-412e-83f4-68c5f2bfc3d8 | Update-VSTeamNuGetPackageVersion -FeedId ber -PackageName Trackyon.Ber -isListed $false
```

This command un-lists every version of Trackyon.Ber in the ber feed.

## PARAMETERS

### FeedId

Name or Id of the feed.

```yaml
Type: String
Required: True
Aliases: feedName
```

### PackageName

Name of the package to update. This cannot be the id.

```yaml
Type: String
Required: True
```

### PackageVersion

Version of the package to update.

```yaml
Type: String[]
Required: True
Aliases: Version
Accept pipeline input: true (ByValue, ByPropertyName)
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VSTeamPackage](Get-VSTeamPackage.md)

[Get-VSTeamPackageVersion](Get-VSTeamPackageVersion.md)
