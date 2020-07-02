<!-- #include "./common/header.md" -->

# Get-VSTeamPullRequest

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamPullRequest.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamPullRequest.md" -->

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
PS C:\> Get-VSTeamPullRequest -ProjectName Demo -All
```

This command returns all pull requests for the Demo team project.

### -------------------------- EXAMPLE 4 --------------------------

```PowerShell
PS C:\> Get-VSTeamPullRequest -ProjectName Demo -TargetBranchRef "refs/heads/mybranch"
```

This command returns all open pull requests for a specific branch

### -------------------------- EXAMPLE 5 --------------------------

```PowerShell
PS C:\> Get-VSTeamPullRequest -Id 123
```

This command gets the pull request with an Id of 123.

### -------------------------- EXAMPLE 6 --------------------------

```PowerShell
PS C:\> Get-VSTeamPullRequest -Id 123 -RepositoryId "93BBA613-2729-4158-9217-751E952AB4AF" -IncludeCommits
```

This command gets the pull request with an Id of 123 and includes the commits that are part of the pull request.

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
Parameter Sets: ById, IncludeCommits
```

### -RepositoryId

The repository ID of the pull request's target branch.

```yaml
Type: Guid
Parameter Sets: SearchCriteriaWithStatus, SearchCriteriaWithAll, ById, IncludeCommits
```

### -SourceRepositoryId

If set, search for pull requests whose source branch is in this repository.

```yaml
Type: Guid
Parameter Sets: SearchCriteriaWithStatus, SearchCriteriaWithAll
```

### -SourceBranchRef

If set, search for pull requests from this branch.

```yaml
Type: String
Parameter Sets: SearchCriteriaWithStatus, SearchCriteriaWithAll
```

### -TargetBranchRef

If set, search for pull requests into this branch.

```yaml
Type: String
Parameter Sets: SearchCriteriaWithStatus, SearchCriteriaWithAll
```

### -Status

If set, search for pull requests that are in this state. Defaults to Active if unset. Valid values for this parameter are:

- abandoned
- active
- all
- completed
- notSet

```yaml
Type: String
Parameter Sets: SearchCriteriaWithStatus
```

### -All

```yaml
Type: Switch
Parameter Sets: SearchCriteriaWithAll
```

### -Top

The number of pull requests to retrieve.

```yaml
Type: Int32
Parameter Sets: SearchCriteriaWithStatus, SearchCriteriaWithAll
```

### -Skip

The number of pull requests to ignore. For example, to retrieve results 101-150, set top to 50 and skip to 100.

```yaml
Type: Int32
Parameter Sets: SearchCriteriaWithStatus, SearchCriteriaWithAll
```

### -IncludeCommits

If set, includes the commits that are part of the pull request. Requires the RepositoryId to be set.

```yaml
Type: Switch
Parameter Sets: IncludeCommits
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Show-VSTeamPullRequest](Show-VSTeamPullRequest.md)
[Add-VSTeamPullRequest](Add-VSTeamPullRequest.md)
[Update-VSTeamPullRequest](Update-VSTeamPullRequest.md)
