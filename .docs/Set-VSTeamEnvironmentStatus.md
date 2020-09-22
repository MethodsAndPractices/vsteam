<!-- #include "./common/header.md" -->

# Set-VSTeamEnvironmentStatus

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamEnvironmentStatus.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Set-VSTeamEnvironmentStatus.md" -->

## EXAMPLES

### Example 1

```powershell
Set-VSTeamEnvironmentStatus -ReleaseId 54 -Id 5 -status inProgress
```

This command will set the status of environment with id 5 of release 54 to inProgress. You can use this call to redeploy an environment.

## PARAMETERS

### EnvironmentId

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

### ReleaseId

Specifies the release by ID.

```yaml
Type: Int32
Required: True
Accept pipeline input: true (ByPropertyName)
```

### Status

The status to set for the environment to canceled, inProgress, notStarted, partiallySucceeded, queued, rejected, scheduled, succeeded or undefined.

```yaml
Type: String
```

### Comment

The comment to set for the status change.

```yaml
Type: String
```

### ScheduledDeploymentTime

The date and time to schedule when setting the status to scheduled.

```yaml
Type: DateTime
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
