<!-- #include "./common/header.md" -->

# Get-VSTeamBuildDefinition

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamBuildDefinition.md" -->

## SYNTAX

## DESCRIPTION

The Get-VSTeamBuildDefinition function gets the build definitions for a team project.

The project name is a Dynamic Parameter which may not be displayed in the syntax above but is mandatory.

With just a project name, this function gets all of the build definitions for that team project.

You can also specify a particular build defintion by ID.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuildDefinition -ProjectName Demo | Format-List *
```

This command gets a list of all build definitions in the demo project.

The pipeline operator (|) passes the data to the Format-List cmdlet, which displays all available properties (*) of the build defintion objects.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Filter

Filters to definitions whose names equal this value. Append a * to filter to definitions whose names start with this value.
For example: MS*

```yaml
Type: String
Parameter Sets: List
```

### -Type

The type of the build definitions to retrieve. The acceptable values for this parameter are:

- build
- xaml
- All

```yaml
Type: String
Parameter Sets: List
Default value: All
```

### -Id

Specifies one or more build definitions by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a build defintion, type Get-VSTeamBuildDefinition.

```yaml
Type: Int32[]
Parameter Sets: ByID
Aliases: BuildDefinitionID
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -Revision

Specifies the specific revision number of the definition to retrieve.

```yaml
Type: Int32
Parameter Sets: ByID
Default value: -1
```

## INPUTS

## OUTPUTS

### Team.BuildDefinition

## NOTES

You can pipe build defintion IDs to this function.

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamBuildDefinition](Add-VSTeamBuildDefinition.md)

[Remove-VSTeamBuildDefinition](Remove-VSTeamBuildDefinition.md)