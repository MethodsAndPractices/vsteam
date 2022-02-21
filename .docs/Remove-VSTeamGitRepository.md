<!-- #include "./common/header.md" -->

# Remove-VSTeamGitRepository

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamGitRepository.md" -->

## SYNTAX

## DESCRIPTION

Remove-VSTeamGitRepository removes the Git repository from your Azure DevOps or Team Foundation Server account.

## EXAMPLES

### Example 1

```powershell
Remove-VSTeamGitRepository -Id 687c53f8-1a82-4e89-9a86-13d51bc4a8d5
```

This command removes all the Git repositories for your TFS or Team Services account.

## PARAMETERS

### Id

Specifies one or more repositories by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a repository, type Get-Repository.

```yaml
Type: Guid[]
Aliases: RepositoryID
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
