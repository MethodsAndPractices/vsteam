<!-- #include "./common/header.md" -->

# Get-VSTeamPackage

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamPackage.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamPackage.md" -->

## EXAMPLES

### Example 1: List all package and versions

```powershell
Get-VSTeamFeed | Get-VSTeamPackage -includeAllVersions
```

This command returns all the packages for all the feeds returned by Get-VSTeamFeed.

### Example 2: List only NuGet packages

```powershell
Get-VSTeamFeed | Get-VSTeamPackage -protocolType NuGet
```

This command only returns NuGet packages for all the feeds returned by Get-VSTeamFeed.

### Example 3: Return only the second package

```powershell
Get-VSTeamPackage -feedName vsteam -Top 1 -Skip 1
```

This command returns the second package from the feed named vsteam

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
Parameter Sets: ById
Accept pipeline input: false
```

### IncludeAllVersions

Returns all versions of the package in the response. Default is latest version only.

```yaml
Type: switch
Position: named
Accept pipeline input: false
```

### IncludeDeleted

Return deleted or unpublished versions of packages in the response.

```yaml
Type: switch
Position: named
Accept pipeline input: false
```

### IncludeDescription

Return the description for every version of each package in the response.

```yaml
Type: switch
Position: named
Accept pipeline input: false
```

### HideUrls

Do not return REST Urls with the response.

```yaml
Type: switch
Position: named
Accept pipeline input: false
```

### ProtocolType

One of the supported artifact package types.

```yaml
Type: string
Position: named
Parameter Sets: List
Accept pipeline input: false
```

### PackageNameQuery

Filter to packages that contain the provided string. Characters in the string must conform to the package name constraints.

```yaml
Type: string
Position: named
Parameter Sets: List
Accept pipeline input: false
```

### Skip

Skip the first N packages (or package versions when GetTopPackageVersions is set)

```yaml
Type: Int32
Parameter Sets: List
```

### Top

Get the top N packages (or package versions when GetTopPackageVersions is set)

```yaml
Type: Int32
Parameter Sets: List
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

[Add-VSTeamFeed](Add-VSTeamFeed.md)

<!-- #include "./common/related.md" -->
