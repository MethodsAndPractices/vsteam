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
PS C:\> Get-VSTeamBuildDefinition -ProjectName Demo | Remove-VSTeamBuildDefinition
```

This command gets a list of all build definitions in the demo project.

The pipeline operator (|) passes the data to the Remove-VSTeamBuildDefinition function, which removes each build definition object.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Id

Specifies one or more build definitions by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a build definition, type Get-VSTeamBuildDefinition.

```yaml
Type: Int32[]
Required: True
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/force.md" -->

## INPUTS

## OUTPUTS

### None

## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the project for which this function gets build definitions.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have to pass the ProjectName with each call.

You can pipe build definition IDs to this function.

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamBuildDefinition](Add-VSTeamBuildDefinition.md)

[Get-VSTeamBuildDefinition](Get-VSTeamBuildDefinition.md)
