#include "./common/header.md"

# Set-VSTeamReleaseStatus

## SYNOPSIS
#include "./synopsis/Set-VSTeamReleaseStatus.md"

## SYNTAX

```
Set-VSTeamReleaseStatus [-ProjectName] <String> [-Id] <Int32[]> [[-Status] <String>] [-Force]
```

## DESCRIPTION
#include "./synopsis/Set-VSTeamReleaseStatus.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Set-VSTeamReleaseStatus -Id 5 -status Abandoned
```

This command will set the status of release with id 5 to Abandoned.

## PARAMETERS

### -Id
Specifies one or more releases by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release type Get-VSTeamRelease.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Status
The status to set for the release Active or Abandoned.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#include "./params/force.md"

#include "./params/projectName.md"

## INPUTS

### System.Int32[]
System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS