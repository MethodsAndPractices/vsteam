<!-- #include "./common/header.md" -->

# Remove-VSTeamIteration

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamIteration.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamIteration.md" -->

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Remove-VSTeamIteration -ProjectName Demo -Path "\MyIteration\Path"
```

This command removes an existing iteration with the path MyIteration/Path to the Demo project. Any work items that are assigned to that path get reassigned to the root iteration, since no reclassification id has been given.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Remove-VSTeamIteration -ProjectName "Demo" -Path "\MyIteration\Path" -ReClassifyId 19
```

This command removes an existing iteration with the path \MyIteration\Path to the Demo project. Any work items that are assigned to that path get reassigned to the iteration with the id 19.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Path

Path of the iteration node.

```yaml
Type: string
```

### -ReClassifyId

Id of an iteration where work items should be reassigned to if they are currently assigned to the iteration being deleted.

```yaml
Type: int
```

<!-- #include "./params/force.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

This function is a wrapper of the base function Remove-VSTeamClassificationNode.md.

## RELATED LINKS

[Remove-VSTeamArea](Add-VSTeamArea.md)

[Remove-VSTeamClassificationNode](Add-VSTeamClassificationNode.md)
