<!-- #include "./common/header.md" -->

# Set-VSTeamReleaseStatus

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamReleaseStatus.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Set-VSTeamReleaseStatus.md" -->

## EXAMPLES

### Example 1

```powershell
Set-VSTeamReleaseStatus -Id 5 -status Abandoned
```

This command will set the status of release with id 5 to Abandoned.

## PARAMETERS

### Id

Specifies one or more releases by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release type Get-VSTeamRelease.

```yaml
Type: Int32[]
Required: True
Accept pipeline input: true (ByPropertyName)
```

### Status

The status to set for the release Active or Abandoned.

```yaml
Type: String
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
