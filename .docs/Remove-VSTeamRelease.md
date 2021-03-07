<!-- #include "./common/header.md" -->

# Remove-VSTeamRelease

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamRelease.md" -->

## SYNTAX

## DESCRIPTION

The Remove-VSTeamRelease function removes the releases for a team project.

The project name is a Dynamic Parameter which may not be displayed in the syntax above but is mandatory.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamRelease -ProjectName demo | Remove-VSTeamRelease
```

This command gets a list of all releases in the demo project.

The pipeline operator (|) passes the data to the Remove-VSTeamRelease function, which removes each release definition object.

## PARAMETERS

### Id

Specifies one or more releases by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release definition, type Get-VSTeamRelease.

```yaml
Type: Int32[]
Required: True
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

### None

## NOTES

You can pipe release definition IDs to this function.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamRelease](Add-VSTeamRelease.md)

[Get-VSTeamRelease](Get-VSTeamRelease.md)
