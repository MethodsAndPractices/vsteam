<!-- #include "./common/header.md" -->

# Remove-VSTeamIteration

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamIteration.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamIteration.md" -->

## EXAMPLES

### Example 1

```powershell
Remove-VSTeamIteration -ProjectName Demo -Path "\MyIteration\Path"
```

This command removes an existing iteration with the path MyIteration/Path to the Demo project. Any work items that are assigned to that path get reassigned to the root iteration, since no reclassification id has been given.

### Example 2

```powershell
Remove-VSTeamIteration -ProjectName "Demo" -Path "\MyIteration\Path" -ReClassifyId 19
```

This command removes an existing iteration with the path \MyIteration\Path to the Demo project. Any work items that are assigned to that path get reassigned to the iteration with the id 19.

## PARAMETERS

### Path

Path of the iteration node.

```yaml
Type: string
Required: True
```

### ReClassifyId

Id of an iteration where work items should be reassigned to if they are currently assigned to the iteration being deleted.

```yaml
Type: int
Required: True
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

This function is a wrapper of the base function Remove-VSTeamClassificationNode.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Remove-VSTeamArea](Add-VSTeamArea.md)

[Remove-VSTeamClassificationNode](Add-VSTeamClassificationNode.md)
