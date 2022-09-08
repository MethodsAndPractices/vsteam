<!-- #include "./common/header.md" -->

# Get-VSTeamPackageVersion

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamPackageVersion.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamPackageVersion.md" -->

## EXAMPLES

### Example 1: Get from pipeline

```powershell
Get-VSTeamPackage vsteam -top 1 | Get-VSTeamPackageVersion
```

This command returns all the versions for all the package returned by Get-VSTeamPackage.

### Example 2: Get using parameters

```powershell
$p = Get-VSTeamPackage vsteam -top 1
Get-VSTeamPackageVersion -feedId $($p.FeedId) -packageId $($p.Id)
```

This command returns all the versions for the packageId.

### Example 3: Get version from package in project feed

```powershell
Get-VSTeamPackageVersion -feedId 1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d -packageId 1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d -projectName MyProject
```

This command returns all the versions for the packageId in the project feed.


## PARAMETERS

### FeedId

Name or Id of the feed.

```yaml
Type: string
Position: 0
Required: true
Aliases: feedName
Accept pipeline input: true (ByValue, ByPropertyName)
```

### PackageId

The package Id (GUID Id, not the package name).

```yaml
Type: guid
Position: 1
Required: true
Aliases: id
Accept pipeline input: true (ByValue, ByPropertyName)
```

### HideUrls

Do not return REST Urls with the response.

```yaml
Type: switch
Position: named
Accept pipeline input: false
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

[Add-VSTeamFeed](Add-VSTeamFeed.md)
