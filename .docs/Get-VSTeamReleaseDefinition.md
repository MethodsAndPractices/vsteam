<!-- #include "./common/header.md" -->

# Get-VSTeamReleaseDefinition

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamReleaseDefinition.md" -->

## SYNTAX

## DESCRIPTION

The Get-VSTeamReleaseDefinition function gets the release definitions for a team project.

The project name is a Dynamic Parameter which may not be displayed in the syntax above but is mandatory.

With just a project name, this function gets all of the release definitions for that team project.

You can also specify a particular release definition by ID.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamReleaseDefinition -ProjectName demo | Format-List *
```

This command gets a list of all release definitions in the demo project.

The pipeline operator (|) passes the data to the Format-List cmdlet, which displays all available properties (*) of the release definition objects.

### Example 2

```powershell
Get-VSTeamReleaseDefinition -ProjectName Demo -id 2 -Json
```

This command returns the raw object returned from the server formatted as a JSON string.

### Example 3

```powershell
Get-VSTeamReleaseDefinition -ProjectName Demo -id 2 -Raw
```

This command returns the raw object returned from the server.

## PARAMETERS

### Expand

Specifies which property should be expanded in the list of Release Definition (environments, artifacts, none).

```yaml
Type: String
Parameter Sets: List
```

### Id

Specifies one or more release definitions by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release definition, type Get-VSTeamReleaseDefinition.

```yaml
Type: Int32[]
Parameter Sets: ByID
Aliases: ReleaseDefinitionID
Accept pipeline input: true (ByPropertyName)
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

### Int[]

## OUTPUTS

### vsteam_lib.ReleaseDefinition

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Add-VSTeamReleaseDefinition](Add-VSTeamReleaseDefinition.md)

[Remove-VSTeamReleaseDefinition](Remove-VSTeamReleaseDefinition.md)
