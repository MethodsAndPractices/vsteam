#include "./common/header.md"

# Get-VSTeamGitRepository

## SYNOPSIS
#include "./synopsis/Get-VSTeamGitRepository.md"

## SYNTAX

### ByID (Default)
```
Get-VSTeamGitRepository [-ProjectName <String>] [-Id <Guid[]>]
```

### ByName
```
Get-VSTeamGitRepository [-ProjectName <String>] [-Name <String[]>]
```

## DESCRIPTION
Get-VSTeamGitRepository gets all the repositories in your Visual Studio Team Services or Team Foundation Server account, or a specific project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-VSTeamGitRepository
```

This command returns all the Git repositories for your TFS or Team Services account.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Get-VSTeamGitRepository -ProjectName Demo
```

This command returns all the Git repositories for the Demo team project.

### -------------------------- EXAMPLE 3 --------------------------
```
PS C:\> git clone (Get-VSTeamGitRepository | select -ExpandProperty remoteurl)
```

This command gets the remote URL and passes it to git clone command.

## PARAMETERS

#include "./params/projectName.md"

### -Id
Specifies one or more repositories by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a repository, type Get-VSTeamGitRepository.

```yaml
Type: Guid[]
Parameter Sets: ByID
Aliases: RepositoryID

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies one or more repositories by name.

To specify multiple names, use commas to separate the names.

To find the name of a repository, type Get-VSTeamGitRepository.

```yaml
Type: String[]
Parameter Sets: ByName

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS