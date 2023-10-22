<!-- #include "./common/header.md" -->

# Get-VSTeamBuildArtifact

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamBuildArtifact.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamBuildArtifact.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamBuildArtifact -Id 150 -ProjectName "MyProject"
```

This command retrieves all artifacts associated with the build having the ID 150 in the project "MyProject".

### Example 2

```powershell
Get-VSTeamBuildArtifact -Id 220 -ProjectName "DevOpsProject"
```

In this example, all artifacts related to the build with the ID 220 within the "DevOpsProject" are fetched.

### Example 3

```powershell
$builds = Get-VSTeamBuild -ProjectName "MyProject"
$builds | ForEach-Object { Get-VSTeamBuildArtifact -Id $_.Id -ProjectName "MyProject" }
```

This example demonstrates how to retrieve artifacts for all builds in the "MyProject". It first fetches all builds in the project and then iterates over each build to retrieve its artifacts.

### Example 4

```powershell
Get-VSTeamBuildArtifact -Id 310 -ProjectName "TestProject" | Where-Object { $_.Name -like "*debug*" }
```

This command fetches all artifacts of the build with ID 310 in the "TestProject" and then filters out artifacts that have a name containing the word "debug".

## PARAMETERS

<!-- #include "./params/buildId.md" -->

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
