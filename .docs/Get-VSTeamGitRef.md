<!-- #include "./common/header.md" -->

# Get-VSTeamGitRef

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamGitRef.md" -->

## SYNTAX

## DESCRIPTION

Get-VSTeamGitRef gets all the refs for the provided repository.

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

### -Filter

A filter to apply to the refs (starts with).

```yaml
Type: string
```

### -FilterContains

A filter to apply to the refs (contains). (Azure DevOps Service and Azure DevOps Server 2019+ only)

```yaml
Type: string
```

### -Top

Maximum number of refs to return. It cannot be bigger than 1000. If it is not provided but continuationToken is, top will default to 100. (Azure DevOps Service and Azure DevOps Server 2019+ only)

```yaml
Type: int
```

### -ContinuationToken

The continuation token used for pagination. (Azure DevOps Service and Azure DevOps Server 2019+ only)

```yaml
Type: string
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
