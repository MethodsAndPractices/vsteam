


# Show-VSTeamPullRequest

## SYNOPSIS

Opens the pull request in the default browser.

## SYNTAX

## DESCRIPTION

Opens the pull request in the default browser.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Show-VSTeamPullRequest 3
```

This command will open a web browser with the pull request id of 3.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Show-VSTeamPullRequest -Id 3
```

This command will open a web browser with the pull request id of 3.

## PARAMETERS

### -PullRequestId

Specifies pull request by ID.

```yaml
Type: Int32
Aliases: PullRequestId
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

### Team.Release

## NOTES

You can pipe the pull request ID to this function.

## RELATED LINKS

[Get-VSTeamPullRequest](Get-VSTeamPullRequest.md)

