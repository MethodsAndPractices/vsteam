


# Add-VSTeamPullRequest

## SYNOPSIS

Create a new Pull Request

## SYNTAX

## DESCRIPTION

Create a new Pull Request

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Set-VSTeamAccount -Account mydemos -Token $(System.AccessToken) -UseBearerToken
PS C:\> $r = Get-VSTeamGitRepository -ProjectName project -Name demorepo
PS C:\> Add-VSTeamPullRequest -ProjectName project -RepositoryId $r.RepositoryId -SourceRefName "refs/heads/mybranch" -TargetRefName "refs/heads/master" -Title "My PR" -Description "My Description" -Draft
```

Create a new pull request as a draft

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 0
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -RepositoryId

Specifies the ID of the repository

```yaml
Type: Guid
Required: True
Aliases: Id
Accept pipeline input: true (ByPropertyName)
```

### -SourceRefName

A source reference, like a branch or commit
Needs to be in ref format like refs/heads/MyBranch

```yaml
Type: String
Required: True
```

### -TargetRefName

A target reference, like a branch or commit
Needs to be in ref format like refs/heads/MyBranch

```yaml
Type: String
Required: True
```

### -Title

The title of the pull request

```yaml
Type: String
Required: True
```

### -Description

The description of the pull request

```yaml
Type: String
Required: True
```

### -Draft

Mark the new pull request as a draft

```yaml
Type: Switch
```

### -Confirm

Prompts you for confirmation before running the function.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
Aliases: cf
```

### -Force

Forces the function without confirmation

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
```

### -WhatIf

Shows what would happen if the function runs.
The function is not run.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
Aliases: wi
```

## INPUTS

## OUTPUTS

### Team.PullRequest

## NOTES

## RELATED LINKS

