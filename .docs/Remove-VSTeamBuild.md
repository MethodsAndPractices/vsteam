#include "./common/header.md"

# Remove-VSTeamBuild

## SYNOPSIS
#include "./synopsis/Remove-VSTeamBuild.md"

## SYNTAX

```
Remove-VSTeamBuild [-ProjectName] <String> [-Id] <Int32[]> [-Force]
```

## DESCRIPTION
#include "./synopsis/Remove-VSTeamBuild.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-VSTeamBuild | Remove-VSTeamBuild -Force
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