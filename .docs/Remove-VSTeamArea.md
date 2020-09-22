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
Remove-VSTeamArea -ProjectName "Demo" -Path "\MyArea\Path" -ReClassifyId 19
```

This command removes an existing area with the path \MyArea\Path to the Demo project. Any work items that are assigned to that path get reassigned to the area with the id 19.

### Example 2

```powershell
Get-VSTeamArea | Remove-VSTeamArea "A1" -Force
```

This command removes an existing area with the path "A1" to the default project. Any work items that are assigned to that path get reassigned to the area with the returned by Get-VSTeamArea.

## PARAMETERS

### Path

Path of the area node.

```yaml
Type: string
Required: True
Position: 0
```

### ReClassifyId

Id of an area where work items should be reassigned to if they are currently assigned to the area being deleted.

```yaml
Type: int
Required: True
Aliases: NodeId
Accept pipeline input: true (ByPropertyName)
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

[Remove-VSTeamClassificationNode](Remove-VSTeamClassificationNode.md)

[Remove-VSTeamIteration](Remove-VSTeamIteration.md)
