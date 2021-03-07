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

### Example 1

```powershell
Get-VSTeamBuildTimeline -ProjectName demo -Id 1 | Format-List *
```

This command gets a list of all timelines of the build with Id 1 in the demo project.

The pipeline operator (|) passes the data to the Format-List cmdlet, which
displays all available properties (*) of the timeline objects.

### Example 2

```powershell
Get-VSTeamBuildTimeline -ProjectName demo -Id 1 -TimelineId 595dac0c-0f1a-4bfd-a35f-e5a838ac71d7 -ChangeId 2 -PlanId 356de525-47a9-4251-80c6-d3849a9d6382
```

This command gets the timelines with build Id 1 and timeline Id 595dac0c-0f1a-4bfd-a35f-e5a838ac71d7. It is filtered with the change ID and plan ID.

### Example 3

```powershell
Get-VSTeamBuildTimeline -ProjectName demo -Id 1 -TimelineId @(1,2)
```

This command gets timelines with IDs 1 and 2 by using the ID parameter.

### Example 4

```powershell
Get-VSTeamBuild | Get-VSTeamBuildTimeline -ProjectName demo
```

This command gets timelines with build Ids from the pipeline.

## PARAMETERS

<!-- #include "./params/BuildIds.md" -->

### TimelineId

Returns the timelines with the given timeline id.

```yaml
Type: Guid
Aliases: TimelineId
Parameter Sets: ByID
```

### ChangeId

Returns the timelines with the given change id.

```yaml
Type: Int32
Parameter Sets: ByID
```

### PlanId

Returns the timelines with the given plan id.

```yaml
Type: Guid
Parameter Sets: ByID
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### vsteam_lib.Build

## NOTES

You can pipe build IDs to this function.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VSTeamBuild](Get-VSTeamBuild.md)