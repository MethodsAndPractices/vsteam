<!-- #include "./common/header.md" -->

# Get-VSTeamRelease

## SYNOPSIS

Gets the releases for a team project.

## SYNTAX

## DESCRIPTION

The Get-VSTeamRelease function gets the releases for a team project.

The project name is a Dynamic Parameter which may not be displayed in the syntax above but is mandatory.

With just a project name, this function gets all of the releases for that team project.

You can also specify a particular release definition by ID.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamRelease -ProjectName demo | Format-List *
```

This command gets a list of all releases in the demo project.

The pipeline operator (|) passes the data to the Format-List cmdlet, which displays all available properties (*) of the release definition objects.

### Example 2

```powershell
Get-VSTeamRelease -ProjectName demo -Id 10 -Raw
```

This command returns the raw object returned from the server.

### Example 3

```powershell
Get-VSTeamRelease -ProjectName demo -Id 10 -Json
```

This command returns the raw object returned from the server formatted as JSON.

### Example 4

```powershell
Get-VSTeamRelease -ProjectName demo -artifactVersionId 7
```

This command returns the associated release for given Id. If the artifact type is a "Build" (Azure Pipelines) then it is the id of the build.

## PARAMETERS

### Expand

Specifies which property should be expanded in the list of Release (environments, artifacts, none).

```yaml
Type: String
Parameter Sets: List
```

### StatusFilter

Draft, Active or Abandoned.

```yaml
Type: String
Parameter Sets: List
```

### DefinitionId

Id of the release definition

```yaml
Type: Int32
Parameter Sets: List
Default value: 0
```

### ArtifactVersionId

Id of the artifact version. Returns the particular release pertaining to given artifact version Id.

```yaml
Type: String
Parameter Sets: List
```

### Top

Specifies the maximum number to return.

```yaml
Type: Int32
Parameter Sets: List
Default value: 0
```

### CreatedBy

Creator of the release.

```yaml
Type: String
Parameter Sets: List
```

### MinCreatedTime

Minimum creation time of releases to be returned.

```yaml
Type: DateTime
Parameter Sets: List
```

### MaxCreatedTime

Maximum creation time of releases to be returned.

```yaml
Type: DateTime
Parameter Sets: List
```

### QueryOrder

Order of the results.

```yaml
Type: String
Parameter Sets: List
```

### ContinuationToken

ContinuationToken is used when retrieving more results than can be returned in one response.

```yaml
Type: String
Parameter Sets: List
```

### Id

Specifies one or more releases by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release definition, type Get-VSTeamRelease.

```yaml
Type: Int32[]
Parameter Sets: ByID, ByIDRaw
Aliases: ReleaseID
Required: True
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

## OUTPUTS

### vsteam_lib.Release

## NOTES

You can pipe release definition IDs to this function.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Add-VSTeamRelease](Add-VSTeamRelease.md)

[Remove-VSTeamRelease](Remove-VSTeamRelease.md)
