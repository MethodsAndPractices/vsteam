<!-- #include "./common/header.md" -->

# Get-VSTeamGitRef

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamGitRef.md" -->

## SYNTAX

## DESCRIPTION

Get-VSTeamGitRef gets all the refs for the provided repository..

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamGitRef -ProjectName Demo
```

This command returns all the Git refs for the Demo team project.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -RepositoryId

Specifies the ID of the repository.

```yaml
Type: Guid
Aliases: ID
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS