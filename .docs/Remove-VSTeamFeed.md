<!-- #include "./common/header.md" -->

# Remove-VSTeamFeed

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamFeed.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamFeed.md" -->

## EXAMPLES

### Example 1

```powershell
Remove-VSTeamFeed -id '00000000-0000-0000-0000-000000000000'
```

This command remove the package feed from the account.

### Example 2

```powershell
Remove-VSTeamFeed -id '00000000-0000-0000-0000-000000000000' -ProjectName 'MyProject'
```

This command remove the package feed from the project.

## PARAMETERS

### FeedId

Specifies the ID of the feed.

```yaml
Type: Guid
Aliases: ID
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
