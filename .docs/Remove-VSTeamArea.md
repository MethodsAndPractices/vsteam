<!-- #include "./common/header.md" -->

# Remove-VSTeamArea

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamArea.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamArea.md" -->

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Remove-VSTeamArea -ProjectName Demo -Path "\MyIteration\Path"
```

This command removes an existing area with the path MyIteration/Path to the Demo project. Any work items that are assigned to that path get reassigned to the root area, since no reclassification id has been given.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Remove-VSTeamArea -ProjectName "Demo" -Path "\MyIteration\Path" -ReClassifyId 19
```

This command removes an existing area with the path \MyIteration\Path to the Demo project. Any work items that are assigned to that path get reassigned to the area with the id 19.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Path

Path of the area node.

```yaml
Type: string
```

### -ReClassifyId

Id of an area where work items should be reassigned to if they are currently assigned to the area being deleted.

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

[Remove-VSTeamClassificationNode](Remove-VSTeamClassificationNode.md)

[Remove-VSTeamIteration](Remove-VSTeamIteration.md)
