#include "./common/header.md"

# Get-Build

## SYNOPSIS
#include "./synopsis/Get-Build.md"

## SYNTAX

### List (Default)
```
Get-Build [-ProjectName] <String> [-Top <Int32>] [-ResultFilter <String>] [-ReasonFilter <String>]
 [-StatusFilter <String>] [-Queues <Int32[]>] [-Definitions <Int32[]>] [-BuildNumber <String>] [-Type <String>]
 [-MaxBuildsPerDefinition <Int32>] [-Properties <String[]>]
```

### ByID
```
Get-Build [-ProjectName] <String> [-Id <Int32[]>]
```

## DESCRIPTION
The Get-Build function gets the builds for a team project.

With just a project name, this function gets all of the builds for that team
project.

You can also specify a particular build by ID.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-Build -ProjectName demo | Format-List *
```

This command gets a list of all builds in the demo project.

The pipeline operator (|) passes the data to the Format-List cmdlet, which
displays all available properties (*) of the build objects.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Get-Build -ProjectName demo -top 5 -resultFilter failed
```

This command gets a list of 5 failed builds in the demo project.

### -------------------------- EXAMPLE 3 --------------------------
```
PS C:\> 1203,1204 | Get-Build -ProjectName demo
```

This command gets builds with IDs 1203 and 1204 by using the pipeline.

### -------------------------- EXAMPLE 4 --------------------------
```
PS C:\> Get-Build -ProjectName demo -ID 1203,1204
```

This command gets builds with IDs 1203 and 1204 by using the ID parameter.

## PARAMETERS

### -Top
Specifies the maximum number to return.

```yaml
Type: Int32
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResultFilter
Specifies the result of the builds to return Succeeded, PartiallySucceeded,
Failed, or Canceled.

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReasonFilter
Specifies the reason the build was created of the builds to return Manual,
IndividualCI, BatchedCI, Schedule, UserCreated, ValidateShelveset,
CheckInShelveset, Triggered, or All.

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StatusFilter
Specifies the status of the builds to return InProgress, Completed,
Cancelling, Postponed, NotStarted, or All.

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Queues
A comma-delimited list of queue IDs that specifies the builds to return.

```yaml
Type: Int32[]
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Definitions
A comma-delimited list of build definition IDs that specifies the builds
to return.

```yaml
Type: Int32[]
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BuildNumber
Returns the build with this build number.

You can also use * for a starts with search i.e.
2015* will return all build numbers that start with 2015.

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### -Type
The type of builds to retrieve.

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxBuildsPerDefinition
The maximum number of builds to retrieve for each definition.

This is only valid when definitions is also specified.

```yaml
Type: Int32
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
A comma-delimited list of extended properties to retrieve.

```yaml
Type: String[]
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#include "./params/projectName.md"

#include "./params/BuildIds.md"

## INPUTS

### You can pipe build IDs to this function.

## OUTPUTS

### Team.Build

## NOTES
This function has a Dynamic Parameter for ProjectName that specifies the
project for which this function gets builds.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)
[Add-Build](Add-Build.md)
[Remove-Build](Remove-Build.md)