<!-- #include "./common/header.md" -->

# Get-VSTeamBuildTag

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamBuildTag.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamBuildTag.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamBuildTag -Id 101 -ProjectName "MyProject"
```

This command retrieves all tags associated with the build having the ID 101 in the project "MyProject".

### Example 2

```powershell
Get-VSTeamBuildTag -Id 202 -ProjectName "DevOpsProject"
```

In this example, all tags related to the build with the ID 202 within the "DevOpsProject" are fetched.

### Example 3

```powershell
$builds = Get-VSTeamBuild -ProjectName "MyProject"
$builds | ForEach-Object { Get-VSTeamBuildTag -Id $_.Id -ProjectName "MyProject" }
```

This example demonstrates how to retrieve tags for all builds in the "MyProject". It first fetches all builds in the project and then iterates over each build to retrieve its tags.

### Example 4

```powershell
Get-VSTeamBuildTag -Id 303 -ProjectName "TestProject" | Where-Object { $_ -like "*release*" }
```

This command fetches all tags of the build with ID 303 in the "TestProject" and then filters out tags that contain the word "release".

## PARAMETERS

<!-- #include "./params/buildId.md" -->

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
