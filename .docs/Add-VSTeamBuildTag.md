<!-- #include "./common/header.md" -->

# Add-VSTeamBuildTag

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamBuildTag.md" -->

## SYNTAX

## DESCRIPTION

Adds a tag to a build.

## EXAMPLES

### Example 1

```powershell
Add-VSTeamBuildTag -Id 12345 -Tags "QA_Passed" -ProjectName "MyProject"
```

This command adds the tag "QA_Passed" to the build with ID 12345 in the project named "MyProject".

### Example 2

```powershell
$builds = Get-VSTeamBuild -ProjectName "MyProject" -Result Succeeded
$builds | Add-VSTeamBuildTag -Tags "ProductionReady"
```

This example first retrieves all builds in the "MyProject" project that have succeeded. It then adds the tag "ProductionReady" to each of these builds.

### Example 3

```powershell
Add-VSTeamBuildTag -Id 67890,12345 -Tags "Reviewed,ReadyForDeploy" -ProjectName "MyProject"
```

This command adds the tags "Reviewed" and "ReadyForDeploy" to the builds with IDs 67890 and 12345 in the project named "MyProject".

### Example 4

```powershell
$tags = "Version2.0", "ReleaseCandidate"
Add-VSTeamBuildTag -Id 98765 -Tags $tags -ProjectName "MyProject"
```

This example adds the tags "Version2.0" and "ReleaseCandidate" to the build with ID 98765 in the project named "MyProject".

### Example 5

```powershell
Add-VSTeamBuildTag -Id 11223 -Tags "RegressionTested" -ProjectName "MyProject" -Confirm
```

This command adds the tag "RegressionTested" to the build with ID 11223 in the project named "MyProject". It will prompt for confirmation before adding the tag.

### Example 6

```powershell
$buildId = 44556
$myTags = "UI_Passed", "Backend_Tested"
Add-VSTeamBuildTag -Id $buildId -Tags $myTags -ProjectName "MyProject" -Force
```

This example adds the tags "UI_Passed" and "Backend_Tested" to the build with ID 44556 in the project named "MyProject". The `-Force` parameter ensures the tags are added without any confirmation prompt.

## PARAMETERS

<!-- #include "./params/buildIds.md" -->

<!-- #include "./params/buildTags.md" -->

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
