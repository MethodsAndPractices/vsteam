<!-- #include "./common/header.md" -->

# Get-VSTeamClassificationNode

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamClassificationNode.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamClassificationNode.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamClassificationNode -StructureGroup "area" -ProjectName "MyProject"
```

This command retrieves all area classification nodes for the specified project "MyProject".

### Example 2

```powershell
Get-VSTeamClassificationNode -StructureGroup "iteration" -Depth 2 -ProjectName "MyProject"
```

This example fetches iteration classification nodes for the "MyProject" with a depth of 2 levels.

### Example 3

```powershell
Get-VSTeamClassificationNode -Path "MyNodePath" -ProjectName "MyProject"
```

This command retrieves the classification node associated with the specified node path "MyNodePath" within the "MyProject" project.

### Example 4

```powershell
Get-VSTeamClassificationNode -Id 12345 -ProjectName "MyProject"
```

This example demonstrates how to retrieve the classification node in "MyProject" using a specific node ID (12345).

## PARAMETERS

### StructureGroup

Structure group of the classification node, area or iteration.

```yaml
Type: string
```

### Depth

Depth of children to fetch.

```yaml
Type: int32
```

### Path

Path of the classification node.

```yaml
Type: string
```

### Id

Integer classification nodes ids.

```yaml
Type: int32[]
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

This function is the base function for Get-VSTeamArea and Get-VSTeamIteration.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Get-VSTeamArea](Get-VSTeamArea.md)

[Get-VSTeamIteration](Get-VSTeamIteration.md)
