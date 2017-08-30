# Get-Build

## SYNOPSIS
Gets the builds for a team project.

## SYNTAX

### Parameter Set 1
```
Get-Build [-ProjectName] <String> [-Top <Int32>] [-ResultFilter <String>] [-ReasonFilter <String>] [-StatusFilter <String>] [-Queues <Int32[]>] [-Definitions <Int32[]>] [-BuildNumber <String>] [-Type <String>] [-MaxBuildsPerDefinition <Int32>] [-Properties <String[]>]
```

### Parameter Set 2
```
Get-Build [-ProjectName] <String> [-Id <Int32[]>]
```

## DESCRIPTION
The Get-Build function gets the builds for a team project.

With just a project name, this function gets all of the builds for that team
project. You can also specify a particular build by ID.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
PS C:\\\>
```powershell
Get-Build -ProjectName demo | Format-List *
```

This command gets a list of all builds in the demo project. The
pipeline operator (\|) passes the data to the Format-List cmdlet, which
displays all available properties (\*) of the build objects.

### -------------------------- EXAMPLE 2 --------------------------
PS C:\\\>
```powershell
Get-Build -ProjectName demo -top 5 -resultFilter failed
```

This command gets a list of 5 failed builds in the demo project.

### -------------------------- EXAMPLE 3 --------------------------
PS C:\\\>
```powershell
1203,1204 | Get-Build -ProjectName demo
```

This command gets builds with IDs 1203 and 1204 by using the pipeline.

### -------------------------- EXAMPLE 4 --------------------------
PS C:\\\>
```powershell
Get-Build -ProjectName demo -ID 1203,1204
```

This command gets builds with IDs 1203 and 1204 by using the ID parameter.

## PARAMETERS

### Top
Specifies the maximum number of builds to return.

```yaml
Type: Int32
Parameter Sets: Parameter Set 1
Aliases: 

Required: false
Position: named
Default Value: 0
Pipeline Input: false
```

### ResultFilter
Specifies the result of the builds to return Succeeded, PartiallySucceeded,
Failed, or Canceled.

```yaml
Type: String
Parameter Sets: Parameter Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### ReasonFilter
Specifies the reason the build was created of the builds to return Manual,
IndividualCI, BatchedCI, Schedule, UserCreated, ValidateShelveset,
CheckInShelveset, Triggered, or All.

```yaml
Type: String
Parameter Sets: Parameter Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### StatusFilter
Specifies the status of the builds to return InProgress, Completed,
Cancelling, Postponed, NotStarted, or All.

```yaml
Type: String
Parameter Sets: Parameter Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### Queues
A comma-delimited list of queue IDs that specifies the builds to return.

```yaml
Type: Int32[]
Parameter Sets: Parameter Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### Definitions
A comma-delimited list of build definition IDs that specifies the builds
to return.

```yaml
Type: Int32[]
Parameter Sets: Parameter Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### BuildNumber
Returns the build with this build number. You can also use \* for a starts
with search i.e. 2015\* will return all build numbers that start with 2015.

```yaml
Type: String
Parameter Sets: Parameter Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### Type
The type of builds to retrieve.

```yaml
Type: String
Parameter Sets: Parameter Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### MaxBuildsPerDefinition
The maximum number of builds to retrieve for each definition. This is only
valid when definitions is also specified.

```yaml
Type: Int32
Parameter Sets: Parameter Set 1
Aliases: 

Required: false
Position: named
Default Value: 0
Pipeline Input: false
```

### Properties
A comma-delimited list of extended properties to retrieve.

```yaml
Type: String[]
Parameter Sets: Parameter Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### ProjectName
Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-DefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: true
Position: 0
Default Value: 
Pipeline Input: True (ByPropertyName)
Dynamic: true
```

### Id
Specifies one or more builds by ID. To specify multiple IDs, use commas to
separate the IDs. To find the ID of a build, type Get-Build.

```yaml
Type: Int32[]
Parameter Sets: Parameter Set 2
Aliases: BuildID

Required: false
Position: named
Default Value: 
Pipeline Input: True (ByValue)
```

## INPUTS

### You can pipe build IDs to this function.


## OUTPUTS

### Team.Build


## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the
project for which this function gets builds.

You can tab complete from a list of avaiable projects.

You can use Set-DefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

[Add-TeamAccount
Set-DefaultProject
Add-Build
Remove-Build]()


*Generated by: PowerShell HelpWriter 2017 v2.1.36*
