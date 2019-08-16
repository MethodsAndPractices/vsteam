


# Set-VSTeamEnvironmentStatus

## SYNOPSIS

Sets the status of a environment to canceled, inProgress, notStarted, partiallySucceeded, queued, rejected, scheduled, succeeded or undefined.

## SYNTAX

## DESCRIPTION

Sets the status of a environment to canceled, inProgress, notStarted, partiallySucceeded, queued, rejected, scheduled, succeeded or undefined.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Set-VSTeamEnvironmentStatus -ReleaseId 54 -Id 5 -status inProgress
```

This command will set the status of environment with id 5 of release 54 to inProgress. You can use this call to redeploy an environment.

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 0
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -EnvironmentId

Specifies one or more environments by ID you wish to deploy.

The Environment Ids are unique for each environment and in each release.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of an environment type Get-VSTeamRelease -expand environments.

```yaml
Type: Int32[]
Aliases: Id
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -ReleaseId

Specifies the release by ID.

```yaml
Type: Int32
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -Status

The status to set for the environment to canceled, inProgress, notStarted, partiallySucceeded, queued, rejected, scheduled, succeeded or undefined.

```yaml
Type: String
```

### -Comment

The comment to set for the status change.

```yaml
Type: String
```

### -ScheduledDeploymentTime

The date and time to schedule when setting the status to scheduled.

```yaml
Type: DateTime
```

### -Force

Forces the function without confirmation

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
```

## INPUTS

## OUTPUTS

## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the project for which this function gets releases.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have to pass the ProjectName with each call.

## RELATED LINKS

