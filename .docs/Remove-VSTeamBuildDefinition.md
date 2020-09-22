<!-- #include "./common/header.md" -->

# Remove-VSTeamBuildDefinition

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamBuildDefinition.md" -->

## SYNTAX

## DESCRIPTION

The Remove-VSTeamBuildDefinition function removes the build definitions for a team project.

The project name is a Dynamic Parameter which may not be displayed in the syntax above but is mandatory.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamBuildDefinition -ProjectName Demo | Remove-VSTeamBuildDefinition
```

This command gets a list of all build definitions in the demo project.

The pipeline operator (|) passes the data to the Remove-VSTeamBuildDefinition function, which removes each build definition object.

## PARAMETERS

### Id

Specifies one or more build definitions by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a build definition, type Get-VSTeamBuildDefinition.

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

You can pipe build definition IDs to this function.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamBuildDefinition](Add-VSTeamBuildDefinition.md)

[Get-VSTeamBuildDefinition](Get-VSTeamBuildDefinition.md)
