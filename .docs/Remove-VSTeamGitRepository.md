<!-- #include "./common/header.md" -->

# Remove-VSTeamGitRepository

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamGitRepository.md" -->

## SYNTAX

## DESCRIPTION

Remove-VSTeamGitRepository removes the Git repository from your Visual Studio Team Services or Team Foundation Server account.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Remove-VSTeamGitRepository -Id 687c53f8-1a82-4e89-9a86-13d51bc4a8d5
```

This command removes all the Git repositories for your TFS or Team Services account.

## PARAMETERS

### -Id

Specifies one or more repositories by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a repository, type Get-Repository.

```yaml
Type: Guid[]
Parameter Sets: (All)
Aliases: RepositoryID
Required: False
Position: Named
Default value: None
Accept pipeline input: true (ByPropertyName)
Accept wildcard characters: False
```

<!-- #include "./params/force.md" -->

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS