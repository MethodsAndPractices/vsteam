


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

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamRelease -ProjectName demo | Format-List *
```

This command gets a list of all releases in the demo project.

The pipeline operator (|) passes the data to the Format-List cmdlet, which displays all available properties (*) of the release definition objects.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamRelease -ProjectName demo -Id 10 -Raw
```

This command returns the raw object returned from the server.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Get-VSTeamRelease -ProjectName demo -Id 10 -Json
```

This command returns the raw object returned from the server formated as JSON.

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

### -Expand

Specifies which property should be expanded in the list of Release (environments, artifacts, none).

```yaml
Type: String
Parameter Sets: List
```

### -StatusFilter

Draft, Active or Abandoned.

```yaml
Type: String
Parameter Sets: List
```

### -DefinitionId

Id of the release definition

```yaml
Type: Int32
Parameter Sets: List
Default value: 0
```

### -Top

Specifies the maximum number to return.

```yaml
Type: Int32
Parameter Sets: List
Default value: 0
```

### -CreatedBy

```yaml
Type: String
Parameter Sets: List
```

### -MinCreatedTime

```yaml
Type: DateTime
Parameter Sets: List
```

### -MaxCreatedTime

```yaml
Type: DateTime
Parameter Sets: List
```

### -QueryOrder

```yaml
Type: String
Parameter Sets: List
```

### -ContinuationToken

```yaml
Type: String
Parameter Sets: List
```

### -Id

Specifies one or more releases by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release definition, type Get-VSTeamRelease.

```yaml
Type: Int32[]
Parameter Sets: ByID, ByIDJson, ByIDRaw
Aliases: ReleaseID
Required: True
Accept pipeline input: true (ByPropertyName)
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

### Team.Release

## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the project for which this function gets releases.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have to pass the ProjectName with each call.

You can pipe release definition IDs to this function.

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamRelease](Add-VSTeamRelease.md)

[Remove-VSTeamRelease](Remove-VSTeamRelease.md)

