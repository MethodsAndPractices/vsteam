<!-- #include "./common/header.md" -->

# Get-VSTeamBuildTimeline

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamBuildTimeline.md" -->

## SYNTAX

## DESCRIPTION

The Get-VSTeamBuildTimeline function gets the timelines for a build.

With just a project name and the build id, this function gets all the timelines of a build for that team project.

You can also specify a particular timeline by ID to get .

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuildTimeline -ProjectName demo -BuildId 1 | Format-List *
```

This command gets a list of all timelines of thr build with Id 1 in the demo project.

The pipeline operator (|) passes the data to the Format-List cmdlet, which
displays all available properties (*) of the timeline objects.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> 84651ddb-8492-4057-b7b7-f6b11008e39f,595dac0c-0f1a-4bfd-a35f-e5a838ac71d7 | Get-VSTeamBuildTimeline -ProjectName demo  -BuildId 1
```

This command gets the timelines with IDs 84651ddb-8492-4057-b7b7-f6b11008e39f and 595dac0c-0f1a-4bfd-a35f-e5a838ac71d7 by using the pipeline.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuildTimeline -ProjectName demo -BuildId 1 -ID 84651ddb-8492-4057-b7b7-f6b11008e39f,595dac0c-0f1a-4bfd-a35f-e5a838ac71d7
```

This command gets timelines with IDs 84651ddb-8492-4057-b7b7-f6b11008e39f and 595dac0c-0f1a-4bfd-a35f-e5a838ac71d7 by using the ID parameter.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -BuildId

Build id where you get the time line from

```yaml
Type: int[]
Parameter Sets: ByID

### -TimelineId

Returns the timelines with the given timeline id.

```yaml
Type: Guid
Parameter Sets: ByID
```

### -ChangeId

Returns the timelines with the given change id.

```yaml
Type: Int32
Parameter Sets: ByID
```

### -PlanId

Returns the timelines with the given plan id.

```yaml
Type: Guid
Parameter Sets: ByID
```

<!-- #include "./params/BuildIds.md" -->

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

[Get-VSTeamBuild](Get-VSTeamBuild.md)