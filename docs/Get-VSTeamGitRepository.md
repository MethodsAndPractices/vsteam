


# Get-VSTeamGitRepository

## SYNOPSIS

Get all the repositories in your Azure DevOps or Team Foundation Server account, or a specific project.

## SYNTAX

## DESCRIPTION

Get-VSTeamGitRepository gets all the repositories in your Azure DevOps or Team Foundation Server account, or a specific project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamGitRepository
```

This command returns all the Git repositories for your TFS or Team Services account.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamGitRepository -ProjectName Demo
```

This command returns all the Git repositories for the Demo team project.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> git clone (Get-VSTeamGitRepository | select -ExpandProperty remoteUrl)
```

This command gets the remote URL and passes it to git clone command.

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

### -Id

Specifies one or more repositories by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a repository, type Get-VSTeamGitRepository.

```yaml
Type: Guid[]
Parameter Sets: ByID
Aliases: RepositoryID
Accept pipeline input: true (ByPropertyName)
```

### -Name

Specifies one or more repositories by name.

To specify multiple names, use commas to separate the names.

To find the name of a repository, type Get-VSTeamGitRepository.

```yaml
Type: String[]
Parameter Sets: ByName
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

