


# Show-VSTeamBuildDefinition

## SYNOPSIS

Opens the build definition in the default browser.

## SYNTAX

## DESCRIPTION

Opens the build definition in the default browser.

The project name is a Dynamic Parameter which may not be displayed in the syntax above but is mandatory.

With just a project name, this function shows all of the build definitions for that team project.

You can also specify a particular build definition by ID.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Show-VSTeamBuildDefinition -ProjectName Demo
```

This command will open a web browser with All Definitions for this project showing.

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

### -Type

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

### -Path

The folder of the build definitions to retrieve.

```yaml
Type: String
Parameter Sets: List
Default value: \
```

### -Id

Specifies build definition by ID.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases: BuildDefinitionID
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

### Team.BuildDefinition

## NOTES

You can pipe build definition IDs to this function.

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamBuildDefinition](Add-VSTeamBuildDefinition.md)

[Remove-VSTeamBuildDefinition](Remove-VSTeamBuildDefinition.md)

