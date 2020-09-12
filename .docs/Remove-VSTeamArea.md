<!-- #include "./common/header.md" -->

# Remove-VSTeamArea

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamArea.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamArea.md" -->

## EXAMPLES

### Example 1

```powershell
PS C:\> Remove-VSTeamArea -ProjectName Demo -Path "\MyIteration\Path"
```

This command removes an existing area with the path MyIteration/Path to the Demo project. Any work items that are assigned to that path get reassigned to the root area, since no reclassification id has been given.

### Example 2

```powershell
PS C:\> Remove-VSTeamArea -ProjectName "Demo" -Path "\MyIteration\Path" -ReClassifyId 19
```

This command removes an existing area with the path \MyIteration\Path to the Demo project. Any work items that are assigned to that path get reassigned to the area with the id 19.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Path

Path of the area node.

```yaml
Type: string
Required: True
```

### -ReClassifyId

Id of an area where work items should be reassigned to if they are currently assigned to the area being deleted.

```yaml
Type: int
Required: True
```

<!-- #include "./params/force.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

This function is a wrapper of the base function Remove-VSTeamClassificationNode.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Remove-VSTeamClassificationNode](Remove-VSTeamClassificationNode.md)

[Remove-VSTeamIteration](Remove-VSTeamIteration.md)
