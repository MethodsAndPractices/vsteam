#include "./common/header.md"

# Remove-Project

## SYNOPSIS
#include "./synopsis/Remove-Project.md"

## SYNTAX

```
Remove-Project [-ProjectName] <String> [-Force]
```

## DESCRIPTION
This will permanently delete your Team Project from your Team Services
account.

This function takes a DynamicParam for ProjectName that can be read from
the Pipeline by Property Name

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Remove-Project 'MyProject'
```

You will be prompted for confirmation and the project will be deleted.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Remove-Project 'MyProject' -Force
```

You will NOT be prompted for confirmation and the project will be deleted.

### -------------------------- EXAMPLE 3 --------------------------
```
PS C:\> Get-Project | Remove-Project -Force
```

This will remove all projects

## PARAMETERS

#include "./params/force.md"

#include "./params/projectName.md"

## INPUTS

### System.String

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Add-Project](Add-Project.md)