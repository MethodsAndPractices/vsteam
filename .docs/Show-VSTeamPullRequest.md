<!-- #include "./common/header.md" -->

# Show-VSTeamPullRequest

## SYNOPSIS

<!-- #include "./synopsis/Show-VSTeamPullRequest.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Show-VSTeamPullRequest.md" -->

## EXAMPLES

### Example 1

```powershell
Show-VSTeamPullRequest 3
```

This command will open a web browser with the pull request id of 3.

### Example 2

```powershell
Show-VSTeamPullRequest -Id 3
```

This command will open a web browser with the pull request id of 3.

## PARAMETERS

### PullRequestId

Specifies pull request by ID.

```yaml
Type: Int32
Aliases: PullRequestId
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

## NOTES

You can pipe the pull request ID to this function.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VSTeamPullRequest](Get-VSTeamPullRequest.md)
