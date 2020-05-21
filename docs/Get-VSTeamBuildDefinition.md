


# Get-VSTeamBuildDefinition

## SYNOPSIS

Gets the build definitions for a team project.

## SYNTAX

## DESCRIPTION

The Get-VSTeamBuildDefinition function gets the build definitions for a team project.

The project name is a Dynamic Parameter which may not be displayed in the syntax above but is mandatory.

With just a project name, this function gets all of the build definitions for that team project.

You can also specify a particular build definition by ID.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuildDefinition -ProjectName Demo | Format-List *
```

This command gets a list of all build definitions in the demo project.

The pipeline operator (|) passes the data to the Format-List cmdlet, which displays all available properties (*) of the build definition objects.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuildDefinition -ProjectName Demo -id 2 -Json
```

This command returns the raw object returned from the server formatted as a JSON string.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuildDefinition -ProjectName Demo -id 2 -Raw
```

This command returns the raw object returned from the server.

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

To find the ID of a build definition, type Get-VSTeamBuildDefinition.

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

### -JSON

Converts the raw response into JSON and displays in the console. This is required when you need to use the object to send back.  Without this switch the JSON produced from the returned object will not match the expected shape of the JSON for sending back to server.

```yaml
Type: Switch
Required: True
Parameter Sets: ByIDJson
```

### -Raw

Returns the raw response. This is required when you need to use the object to send back.  Without this switch the object produced from the returned object will not match the expected shape of the JSON for sending back to server.

```yaml
Type: Switch
Required: True
Parameter Sets: ByIDRaw
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

