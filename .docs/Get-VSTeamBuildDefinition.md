<!-- #include "./common/header.md" -->

# Get-VSTeamBuildDefinition

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamBuildDefinition.txt" -->

## SYNTAX

## DESCRIPTION

The Get-VSTeamBuildDefinition function gets the build definitions for a team project.

The project name is a Dynamic Parameter which may not be displayed in the syntax above but is mandatory.

With just a project name, this function gets all of the build definitions for that team project.

You can also specify a particular build definition by ID.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamBuildDefinition -ProjectName Demo | Format-List *
```

This command gets a list of all build definitions in the demo project.

The pipeline operator (|) passes the data to the Format-List cmdlet, which displays all available properties (*) of the build definition objects.

### Example 2

```powershell
Get-VSTeamBuildDefinition -ProjectName Demo -id 2 -Json
```

This command returns the raw object returned from the server formatted as a JSON string.

### Example 3

```powershell
Get-VSTeamBuildDefinition -ProjectName Demo -id 2 -Raw
```

This command returns the raw object returned from the server.

## PARAMETERS

### Filter

Filters to definitions whose names equal this value. Append a * to filter to definitions whose names start with this value.
For example: MS*

```yaml
Type: String
Parameter Sets: List
```

### Id

Specifies one or more build definitions by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a build definition, type Get-VSTeamBuildDefinition.

```yaml
Type: Int32[]
Parameter Sets: ByID
Aliases: BuildDefinitionID
Required: True
Accept pipeline input: true (ByPropertyName)
```

### Revision

Specifies the specific revision number of the definition to retrieve.

```yaml
Type: Int32
Parameter Sets: ByID
Default value: -1
```

### JSON

Converts the raw response into JSON and displays in the console. This is required when you need to use the object to send back.  Without this switch the JSON produced from the returned object will not match the expected shape of the JSON for sending back to server.

```yaml
Type: Switch
Required: True
```

### Raw

Returns the raw response. This is required when you need to use the object to send back.  Without this switch the object produced from the returned object will not match the expected shape of the JSON for sending back to server.

```yaml
Type: Switch
Required: True
Parameter Sets: ByIDRaw
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
