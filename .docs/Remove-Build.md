#include "./common/header.md"

# Remove-Build

## SYNOPSIS
#include "./synopsis/Remove-Build.md"

## SYNTAX

```
Remove-Build [-ProjectName] <String> [-Id] <Int32[]> [-Force]
```

## DESCRIPTION
#include "./synopsis/Remove-Build.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-Build | Remove-Build -Force
```

This command will delete all builds that are not marked retain indefinitely.

## PARAMETERS

#include "./params/BuildIds.md"

#include "./params/force.md"

#include "./params/projectName.md"

## INPUTS

### System.Int32[]
System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS