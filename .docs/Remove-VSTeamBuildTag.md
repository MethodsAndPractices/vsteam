<!-- #include "./common/header.md" -->

# Remove-VSTeamBuildTag

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamBuildTag.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamBuildTag.md" -->

## EXAMPLES

### Example 1
```powershell
Remove-VSTeamBuildTag -BuildId 1001 -Tag "ReleaseCandidate"
```

Removes the "ReleaseCandidate" tag from the build with ID `1001`.

### Example 2
```powershell
Remove-VSTeamBuildTag -BuildId 1001 -Tag "ReleaseCandidate" -ProjectName "MyProject"
```

Removes the "ReleaseCandidate" tag from the build with ID `1001` within the "MyProject" project.

### Example 3
```powershell
$tagsToRemove = "ReleaseCandidate", "Beta", "Alpha"
$tagsToRemove | ForEach-Object { Remove-VSTeamBuildTag -BuildId 1001 -Tag $_ }
```

Removes multiple tags "ReleaseCandidate", "Beta", and "Alpha" from the build with ID `1001`.

### Example 4
```powershell
Remove-VSTeamBuildTag -BuildId 1001 -Tag "ReleaseCandidate" -Force
```

Removes the "ReleaseCandidate" tag from the build with ID `1001` and forces the removal without any confirmation prompts.

## PARAMETERS

<!-- #include "./params/buildIds.md" -->

<!-- #include "./params/buildTags.md" -->

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
