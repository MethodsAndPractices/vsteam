<!-- #include "./common/header.md" -->

# Remove-VSTeamClassificationNode

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamClassificationNode.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamClassificationNode.md" -->

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Remove-VSTeamClassificationNode -ProjectName Demo -StructureGroup "iterations" -Path "\MyIteration\Path"
```

This command removes an existing iteration with the path MyIteration/Path to the Demo project. Any work items that are assigned to that path get reassigned to the root iteration, since no reclassification id has been given.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Remove-VSTeamClassificationNode -ProjectName "Demo" -StructureGroup "areas" -Path "\MyIteration\Path" -ReClassifyId 19
```

This command removes an existing area with the path \MyIteration\Path to the Demo project. Any work items that are assigned to that path get reassigned to the area with the id 19.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -StructureGroup

Structure group of the classification node.

```yaml
Type: string
Accepted values: iterations, areas
```

### -Path

Path of the classification node.

```yaml
Type: string
```

### -ReClassifyId

Id of a classification node where work items should be reassigned to if they are currently assigned to the node being deleted.

```yaml
Type: int
```

<!-- #include "./params/force.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

This function is the base function for Remove-VSTeamArea and Remove-VSTeamIteration.

## RELATED LINKS

[Remove-VSTeamArea](Remove-VSTeamArea.md)

[Remove-VSTeamIteration](Remove-VSTeamIteration.md)
