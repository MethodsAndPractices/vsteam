<!-- #include "./common/header.md" -->

# Add-VSTeamGitRepository

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamGitRepository.md" -->

## SYNTAX

## DESCRIPTION

Add-VSTeamGitRepository adds a Git repository to your Azure DevOps or Team Foundation Server account.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Add-VSTeamGitRepository -ProjectName Demo -Name Temp
```

This command adds a new repository named Temp to the Demo project.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Name

Specifies the name of the repository.

```yaml
Type: System.String
Aliases: RepositoryID
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
