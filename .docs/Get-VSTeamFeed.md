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

### FeedId

Specifies the ID of the feed.

```yaml
Type: Guid
Aliases: ID
Parameter Sets: ByID
Accept pipeline input: true (ByPropertyName)
```

### Scope

Specifies the scope of the feed. Valid values are 'organization' or 'project'.

```yaml
Type: String
Parameter Sets: ByScope
Accepted values: organization, project
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
