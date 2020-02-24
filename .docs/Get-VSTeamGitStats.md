<!-- #include "./common/header.md" -->

# Get-VSTeamGitStats

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamGitStats.md" -->

## SYNTAX

## DESCRIPTION

Get-VSTeamGitStats retrieves statistics about branches within a repository.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamGitStats -ProjectName Demo -RepositoryId 011E421A-2A54-4491-B370-9256AD8A1BDD
```

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamGitStats -ProjectName Demo -RepositoryId 011E421A-2A54-4491-B370-9256AD8A1BDD -BranchName develop
```

This command returns all the Git stats for a specific branch

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Get-VSTeamGitStats -ProjectName Demo -RepositoryId 011E421A-2A54-4491-B370-9256AD8A1BDD -BranchName develop -VersionType branch -Version 67cae2b029dff7eb3dc062b49403aaedca5bad8d
```

This command returns all the Git stats for a specific commit

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -RepositoryId

Specifies the ID of the repository.

```yaml
Type: Guid
Aliases: ID
Mandatory: true
Accept pipeline input: true (ByPropertyName)
```

### -BranchName

Name of the branch.

```yaml
Type: String
Mandatory: true
```

### -VersionOptions

Version options - Specify additional modifiers to version (e.g Previous). Valid options for this parameter are:

- firstParent
- none
- previousChange

```yaml
Type: String
Parameter Sets: ByVersion
```

### -Version

Version string identifier (name of tag/branch, SHA1 of commit)

```yaml
Type: String
Parameter Sets: ByVersion
```

### -VersionType

Version type (branch, tag, or commit). Determines how Id is interpreted. Valid options for this parameter are:

- branch
- commit
- tag

```yaml
Type: String
Parameter Sets: ByVersion
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
