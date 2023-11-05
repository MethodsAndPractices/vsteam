<!-- #include "./common/header.md" -->

# Get-VSTeamFeed

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamFeed.md" -->

## SYNTAX

## DESCRIPTION

Get-VSTeamFeed gets all the feeds for the account

## EXAMPLES

### Example 1

```powershell
Get-VSTeamFeed
```

This command returns all the package feeds for the account.

### Example 2

```powershell
Get-VSTeamFeed -ProjectName 'MyProject'
```

This command returns all the package feeds for the project.

## PARAMETERS

### Id

Specifies the ID of the feed.

```yaml
Type: Guid
Aliases: FeedId
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
