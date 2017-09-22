#include "./common/header.md"

# Add-VSTeamGitRepository

## SYNOPSIS
#include "./synopsis/Add-VSTeamGitRepository.md"

## SYNTAX

```
Add-VSTeamGitRepository [-ProjectName <String>] [-Name <System.String>]
```

## DESCRIPTION
Add-VSTeamGitRepository adds a Git repository to your Visual Studio Team Services or Team Foundation Server account.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Add-VSTeamGitRepository -ProjectName Demo -Name Temp
```

This command adds a new repository named Temp to the Demo project.

## PARAMETERS

#include "./params/projectName.md"

### -Name
Specifies the name of the repository.

```yaml
Type: System.String
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