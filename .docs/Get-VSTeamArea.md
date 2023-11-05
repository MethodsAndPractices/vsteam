<!-- #include "./common/header.md" -->

# Get-VSTeamArea

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamArea.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamArea.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamArea -Path "Features\Login" -ProjectName "MyProject"
```

This command retrieves the area node corresponding to the "Login" area under the "Features" path in the project "MyProject".

### Example 2

```powershell
Get-VSTeamArea -Id 45 -ProjectName "DevOpsProject"
```

In this example, the area node with the ID 45 within the "DevOpsProject" is fetched.

### Example 3

```powershell
Get-VSTeamArea -Depth 2 -Path "Features" -ProjectName "MyProject"
```

This example demonstrates how to retrieve the area node for the "Features" path in the project "MyProject", including its children up to a depth of 2.

### Example 4

```powershell
$areas = Get-VSTeamArea -ProjectName "MyProject"
$areas | Where-Object { $_.Name -like "*UI*" }
```

This command fetches all area nodes in the "MyProject" and then filters out areas that have a name containing the word "UI".

## PARAMETERS

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

This is a wrapper function for Get-VSTeamClassificationNode

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Get-VSTeamClassificationNode](Get-VSTeamClassificationNode.md)

[Get-VSTeamIteration](Get-VSTeamIteration.md)
