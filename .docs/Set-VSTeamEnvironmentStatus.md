#include "./common/header.md"

# Set-VSTeamEnvironmentStatus

## SYNOPSIS
#include "./synopsis/Set-VSTeamEnvironmentStatus.md"

## SYNTAX

```
Set-VSTeamEnvironmentStatus [-ProjectName] <String> [-ReleaseId] <Int32> [-Id] <Int32[]> [-Status] <String> [[-Comment] <String>] [[-ScheduledDeploymentTime] <DateTime>]  [-Force]
```

## DESCRIPTION
#include "./synopsis/Set-VSTeamEnvironmentStatus.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Set-VSTeamEnvironmentStatus -ReleaseId 54 -Id 5 -status inProgress
```

This command will set the status of environment with id 5 of release 54 to inProgress. You can use this call to redeploy an environment.

## PARAMETERS

### -Id
Specifies one or more environments by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of an environment type Get-VSTeamRelease -expand environments.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: EnvironmentId

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReleaseId
Specifies the release by ID.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Status
The status to set for the environment to canceled, inProgress, notStarted, partiallySucceeded, queued, rejected, scheduled, succeeded or undefined.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Comment
The comment to set for the status change.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScheduledDeploymentTime
The date and time to schedule when setting the status to scheduled.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
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