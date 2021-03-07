<!-- #include "./common/header.md" -->

# Add-VSTeamGitRepository

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamGitRepository.md" -->

## SYNTAX

## DESCRIPTION

Add-VSTeamGitRepository adds a Git repository to your Azure DevOps or Team Foundation Server account.

## EXAMPLES

### Example 1

```powershell
Add-VSTeamGitRepository -ProjectName Demo -Name Temp
```

This command adds a new repository named Temp to the Demo project.

## PARAMETERS

### Name

Specifies the name of the repository.

```yaml
Type: System.String
Aliases: RepositoryID
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
