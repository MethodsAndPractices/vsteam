<!-- #include "./common/header.md" -->

# Set-VSTeamReleaseStatus

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamReleaseStatus.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Set-VSTeamReleaseStatus.md" -->

## EXAMPLES

### Example 1

```PowerShell
PS C:\> Set-VSTeamReleaseStatus -Id 5 -status Abandoned
```

This command will set the status of release with id 5 to Abandoned.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Id

Specifies one or more releases by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release type Get-VSTeamRelease.

```yaml
Type: Int32[]
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -Status

The status to set for the release Active or Abandoned.

```yaml
Type: String
```

<!-- #include "./params/force.md" -->

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
