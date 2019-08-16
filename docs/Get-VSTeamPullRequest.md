


# Get-VSTeamPullRequest

## SYNOPSIS

Returns one or more a work items from your project.

## SYNTAX

## DESCRIPTION

Returns one or more a work items from your project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamPullRequest
```

This command returns all the open pull requests for your TFS or Team Services account.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamPullRequest -ProjectName Demo
```

This command returns all the open pull requests for the Demo team project.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Get-VSTeamPullRequest -Id 123
```

This command gets the pull request with an Id of 123.

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Required: false
Position: 0
Accept pipeline input: true (ByPropertyName)
```

### -Id

Specifies the pull request by ID.

```yaml
Type: String
Aliases: PullRequestId
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Show-VSTeamPullRequest](Show-VSTeamPullRequest.md)

