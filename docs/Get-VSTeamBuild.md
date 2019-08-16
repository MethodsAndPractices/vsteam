


# Get-VSTeamBuild

## SYNOPSIS

Gets the builds for a team project.

## SYNTAX

## DESCRIPTION

The Get-VSTeamBuild function gets the builds for a team project.

With just a project name, this function gets all of the builds for that team project.

You can also specify a particular build by ID.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuild -ProjectName demo | Format-List *
```

This command gets a list of all builds in the demo project.

The pipeline operator (|) passes the data to the Format-List cmdlet, which
displays all available properties (*) of the build objects.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuild -ProjectName demo -top 5 -resultFilter failed
```

This command gets a list of 5 failed builds in the demo project.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> 1203,1204 | Get-VSTeamBuild -ProjectName demo
```

This command gets builds with IDs 1203 and 1204 by using the pipeline.

### -------------------------- EXAMPLE 4 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuild -ProjectName demo -ID 1203,1204
```

This command gets builds with IDs 1203 and 1204 by using the ID parameter.

### -------------------------- EXAMPLE 5 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuild -ProjectName demo -ID 1203 -Raw
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

### -Top

Specifies the maximum number to return.

```yaml
Type: Int32
Parameter Sets: List
Default value: 0
```

### -ResultFilter

Specifies the result of the builds to return Succeeded, PartiallySucceeded, Failed, or Canceled.

```yaml
Type: String
Parameter Sets: List
```

### -ReasonFilter

Specifies the reason the build was created of the builds to return Manual, IndividualCI, BatchedCI, Schedule, UserCreated, ValidateShelveSet, CheckInShelveSet, Triggered, or All.

```yaml
Type: String
Parameter Sets: List
```

### -StatusFilter

Specifies the status of the builds to return InProgress, Completed, Cancelling, Postponed, NotStarted, or All.

```yaml
Type: String
Parameter Sets: List
```

### -Queues

A comma-delimited list of queue IDs that specifies the builds to return.

```yaml
Type: Int32[]
Parameter Sets: List
```

### -Definitions

A comma-delimited list of build definition IDs that specifies the builds to return.

```yaml
Type: Int32[]
Parameter Sets: List
```

### -BuildNumber

Returns the build with this build number.

You can also use * for a starts with search.
For example: 2015*
Will return all build numbers that start with 2015.

```yaml
Type: String
Parameter Sets: List
```

### -Type

The type of builds to retrieve.

```yaml
Type: String
Parameter Sets: List
```

### -MaxBuildsPerDefinition

The maximum number of builds to retrieve for each definition.

This is only valid when definitions is also specified.

```yaml
Type: Int32
Parameter Sets: List
```

### -Properties

A comma-delimited list of extended properties to retrieve.

```yaml
Type: String[]
Parameter Sets: List
```

### -Id

Specifies one or more builds by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a build, type Get-VSTeamBuild.

```yaml
Type: Int32[]
Aliases: BuildID
Accept pipeline input: true (ByPropertyName, ByValue)
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

### Team.Build

## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the project for which this function gets builds.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have to pass the ProjectName with each call.

You can pipe build IDs to this function.

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamBuild](Add-VSTeamBuild.md)

[Remove-VSTeamBuild](Remove-VSTeamBuild.md)

