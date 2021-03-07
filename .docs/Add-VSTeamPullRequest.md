<!-- #include "./common/header.md" -->

# Add-VSTeamPullRequest

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamPullRequest.md" -->

## SYNTAX

## DESCRIPTION

Create a new Pull Request

## EXAMPLES

### Example 1

```powershell
Set-VSTeamAccount -Account mydemos -Token $(System.AccessToken) -UseBearerToken
$r = Get-VSTeamGitRepository -ProjectName project -Name demorepo
Add-VSTeamPullRequest -ProjectName project -RepositoryId $r.RepositoryId -SourceRefName "refs/heads/mybranch" -TargetRefName "refs/heads/trunk" -Title "My PR" -Description "My Description" -Draft
```

Create a new pull request as a draft

## PARAMETERS

### RepositoryId

Specifies the ID of the repository

```yaml
Type: Guid
Required: True
Aliases: Id
Accept pipeline input: true (ByPropertyName)
```

### SourceRefName

A source reference, like a branch or commit
Needs to be in ref format like refs/heads/MyBranch

```yaml
Type: String
Required: True
```

### TargetRefName

A target reference, like a branch or commit
Needs to be in ref format like refs/heads/MyBranch

```yaml
Type: String
Required: True
```

### Title

The title of the pull request

```yaml
Type: String
Required: True
```

### Description

The description of the pull request

```yaml
Type: String
Required: True
```

### Draft

Mark the new pull request as a draft

```yaml
Type: Switch
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

### vsteam_lib.PullRequest

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
