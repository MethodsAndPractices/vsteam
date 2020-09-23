<!-- #include "./common/header.md" -->

# Show-VSTeamBuildDefinition

## SYNOPSIS

<!-- #include "./synopsis/Show-VSTeamBuildDefinition.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Show-VSTeamBuildDefinition.md" -->

The project name is a Dynamic Parameter which may not be displayed in the syntax above but is mandatory.

With just a project name, this function shows all of the build definitions for that team project.

You can also specify a particular build definition by ID.

## EXAMPLES

### Example 1

```powershell
Show-VSTeamBuildDefinition -ProjectName Demo
```

This command will open a web browser with All Definitions for this project showing.

## PARAMETERS

### Type

The type of the build definitions to retrieve.  The acceptable values for this parameter are:

- Mine
- All
- Queued
- XAML

If not specified, all types will be returned.

```yaml
Type: String
Parameter Sets: List
Default value: All
```

### Path

The folder of the build definitions to retrieve.

```yaml
Type: String
Parameter Sets: List
Default value: \
```

### Id

Specifies build definition by ID.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases: BuildDefinitionID
Required: True
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### vsteam_lib.BuildDefinition

## NOTES

You can pipe build definition IDs to this function.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamBuildDefinition](Add-VSTeamBuildDefinition.md)

[Remove-VSTeamBuildDefinition](Remove-VSTeamBuildDefinition.md)
