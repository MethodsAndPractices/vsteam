---
external help file: Team-Help.xml
Module Name: 
online version: 
schema: 2.0.0
---

# Remove-GitRepository

## SYNOPSIS
Removes the Git repository from your Visual Studio Team Services or Team Founcation Server account.

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

### -ProjectName
Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-DefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

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

