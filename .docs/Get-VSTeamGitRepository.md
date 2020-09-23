<!-- #include "./common/header.md" -->

# Get-VSTeamGitRepository

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamGitRepository.md" -->

## SYNTAX

## DESCRIPTION

Get-VSTeamGitRepository gets all the repositories in your Azure DevOps or Team Foundation Server account, or a specific project.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamGitRepository
```

This command returns all the Git repositories for your TFS or Team Services account.

### Example 2

```powershell
Get-VSTeamGitRepository -ProjectName Demo
```

This command returns all the Git repositories for the Demo team project.

### Example 3

```powershell
git clone (Get-VSTeamGitRepository | select -ExpandProperty remoteUrl)
```

This command gets the remote URL and passes it to git clone command.

## PARAMETERS

### Id

Specifies one or more repositories by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a repository, type Get-VSTeamGitRepository.

```yaml
Type: Guid[]
Parameter Sets: ByID
Aliases: RepositoryID
Accept pipeline input: true (ByPropertyName)
```

### Name

Specifies one or more repositories by name.

To specify multiple names, use commas to separate the names.

To find the name of a repository, type Get-VSTeamGitRepository.

```yaml
Type: String[]
Parameter Sets: ByName
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
