#include "./common/header.md"

# Get-GitRepository

## SYNOPSIS
#include "./synopsis/Get-GitRepository.md"

## SYNTAX

```
Get-GitRepository [-ProjectName <String>] [-Id <Guid[]>]
```

## DESCRIPTION
Get-GitRepository gets all the repositories in your Visual Studio Team Services or Team Foundation Server account, or a specific project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-GitRepository
```

This command returns all the Git repositories for your TFS or Team Services account.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Get-GitRepository -ProjectName Demo
```

This command returns all the Git repositories for the Demo team project.

### -------------------------- EXAMPLE 3 --------------------------
```
PS C:\> git clone (Get-GitRepository | select -ExpandProperty remoteurl)
```

This command gets the remote URL and passes it to git clone command.

## PARAMETERS

#include "./params/projectName.md"

### -Id
Specifies one or more repositories by ID.
To specify multiple IDs, use
commas to separate the IDs.
To find the ID of a repository, type
Get-Repository.

```yaml
Type: Guid[]
Parameter Sets: (All)
Aliases: RepositoryID

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

