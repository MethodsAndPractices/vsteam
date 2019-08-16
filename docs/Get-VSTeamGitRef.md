


# Get-VSTeamGitRef

## SYNOPSIS

Queries the provided repository for its refs and returns them.

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

