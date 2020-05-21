<!-- #include "./common/header.md" -->

# Stop-VSTeamBuild

## SYNOPSIS

<!-- #include "./synopsis/Stop-VSTeamBuild.md" -->

## SYNTAX

## DESCRIPTION

Stop-VSTeamBuild will cancel a build using the build id.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Set-VSTeamDefaultProject Demo
PS C:\> Stop-VSTeamBuild -id 1
```

This example cancels the build with build id 1.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Set-VSTeamDefaultProject Demo
PS C:\> $buildsToCancel = Get-VSTeamBuild -StatusFilter "inProgress" | where-object definitionName -eq Build-Defenition-Name
PS C:\> ForEach($build in $buildsToCancel) { Stop-VSTeamBuild -id $build.id }
```

This example will find all builds with a status of "inProgress" and a defenitionName of "Build-Defenition-Name" and then cancel each of these builds.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/BuildId.md" -->

<!-- #include "./params/confirm.md" -->

<!-- #include "./params/whatIf.md" -->

## INPUTS

### System.String

ProjectName

### System.Int32

BuildId

## OUTPUTS

## NOTES

## RELATED LINKS
