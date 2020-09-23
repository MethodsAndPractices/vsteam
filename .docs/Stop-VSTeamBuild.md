<!-- #include "./common/header.md" -->

# Stop-VSTeamBuild

## SYNOPSIS

<!-- #include "./synopsis/Stop-VSTeamBuild.md" -->

## SYNTAX

## DESCRIPTION

Stop-VSTeamBuild will cancel a build using the build id.

## EXAMPLES

### Example 1

```powershell
Set-VSTeamDefaultProject Demo
Stop-VSTeamBuild -id 1
```

This example cancels the build with build id 1.

### Example 3

```powershell
Set-VSTeamDefaultProject Demo
$buildsToCancel = Get-VSTeamBuild -StatusFilter "inProgress" | where-object definitionName -eq Build-Defenition-Name
ForEach($build in $buildsToCancel) { Stop-VSTeamBuild -id $build.id }
```

This example will find all builds with a status of "inProgress" and a defenitionName of "Build-Defenition-Name" and then cancel each of these builds.

## PARAMETERS

<!-- #include "./params/BuildId.md" -->

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

### System.String

ProjectName

### System.Int32

BuildId

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
