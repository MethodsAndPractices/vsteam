#include "./common/header.md"

# Show-VSTeamGitRepository

## SYNOPSIS
#include "./synopsis/Show-VSTeamGitRepository.md"

## SYNTAX

### ByName
```
Show-VSTeamGitRepository [-ProjectName <String>] -RemoteUrl <String>
```

## DESCRIPTION
#include "./synopsis/Show-VSTeamGitRepository.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Show-VSTeamGitRepository -ProjectName Demo
```

This command opens the Git repository in a browser.

## PARAMETERS

#include "./params/projectName.md"

### -RemoteUrl
The RemoteUrl of the Git repository to open.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS