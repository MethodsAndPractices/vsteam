---
external help file: Team-Help.xml
Module Name: 
online version: 
schema: 2.0.0
---

# Add-GitRepository

## SYNOPSIS
Adds a Git repository to your Visual Studio Team Services or Team Founcation Server account.

## SYNTAX

```
Add-GitRepository [-ProjectName <String>] [-Name <System.String>]
```

## DESCRIPTION
Add-GitRepository adds a Git repository to your Visual Studio Team Services or Team Founcation Server account.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Add-GitRepository -ProjectName Demo -Name Temp
```

This command adds a new repository named Temp to the Demo project.

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

