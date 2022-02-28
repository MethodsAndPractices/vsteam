<!-- #include "./common/header.md" -->

# Get-VSTeamGitStat

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamGitStat.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamGitStat.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamGitStat -ProjectName Demo -RepositoryId 011E421A-2A54-4491-B370-9256AD8A1BDD
```

This command returns all the Git stats for the entire repository

### Example 2

```powershell
Get-VSTeamGitStat -ProjectName Demo -RepositoryId 011E421A-2A54-4491-B370-9256AD8A1BDD -BranchName develop
```

This command returns all the Git stats for a specific branch

### Example 3

```powershell
Get-VSTeamGitStat -ProjectName Demo -RepositoryId 011E421A-2A54-4491-B370-9256AD8A1BDD -BranchName develop -VersionType branch -Version 67cae2b029dff7eb3dc062b49403aaedca5bad8d
```

This command returns all the Git stats for a specific commit

## PARAMETERS

### RepositoryId

Specifies the ID of the repository.

```yaml
Type: Guid
Aliases: ID
Required: true
Accept pipeline input: true (ByPropertyName)
```

### BranchName

Name of the branch.

```yaml
Type: String
Required: true
```

### VersionOptions

Version options - Specify additional modifiers to version (e.g Previous). Valid options for this parameter are:

- firstParent
- none
- previousChange

```yaml
Type: String
Parameter Sets: ByVersion
```

### Version

Version string identifier (name of tag/branch, SHA1 of commit)

```yaml
Type: String
Parameter Sets: ByVersion
```

### VersionType

Version type (branch, tag, or commit). Determines how Id is interpreted. Valid options for this parameter are:

- branch
- commit
- tag

```yaml
Type: String
Parameter Sets: ByVersion
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
