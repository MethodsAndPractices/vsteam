


# Add-VSTeamGitRepository

## SYNOPSIS

Adds a Git repository to your Azure DevOps or Team Foundation Server account.

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

