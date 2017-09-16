#include "./common/header.md"

# Remove-GitRepository

## SYNOPSIS
#include "./synopsis/Remove-GitRepository.md"

## SYNTAX

```
Remove-GitRepository [-ProjectName <String>] [-Id <Guid[]>] [-Force]
```

## DESCRIPTION
Remove-GitRepository removes the Git repository from your Visual Studio Team Services or Team Founcation Server account.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Remove-GitRepository -Id 687c53f8-1a82-4e89-9a86-13d51bc4a8d5
```

This command removes all the Git repositories for your TFS or Team Services account.

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

### -Force
Removes the specified repository without prompting for confirmation.
By default, Remove-GitRepository prompts for confirmation before
removing any repository.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

