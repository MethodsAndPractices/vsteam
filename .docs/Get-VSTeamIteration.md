<!-- #include "./common/header.md" -->

# Get-VSTeamIteration

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamIteration.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamIteration.md" -->

## EXAMPLES

### Example 1
```powershell
Get-VSTeamIteration -Path '\ProjectX\Sprint1'
```

This command returns the iteration node for the given iteration path '\ProjectX\Sprint1'.

### Example 2
```powershell
Get-VSTeamIteration -Id 12345
```

This command returns the iteration node for the given classification node id 12345.

### Example 3
```powershell
Get-VSTeamIteration -Path '\ProjectX\Sprint1' -Depth 2
```

This command returns the iteration node for the given iteration path '\ProjectX\Sprint1' and fetches children up to a depth of 2.

### Example 4
```powershell
Get-VSTeamIteration -ProjectName 'ProjectX' | Where-Object { $_.Name -eq "Sprint1" }
```

This command retrieves all iteration nodes from 'ProjectX' and then filters out to display only the node named "Sprint1".

### Example 5
```powershell
Get-VSTeamIteration -Path '\ProjectX\Sprint1' -ProjectName 'ProjectX'
```

This command retrieves the iteration node with the path '\ProjectX\Sprint1' that is part of 'ProjectX'.

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

Keep in mind that the `Get-VSTeamIteration` function is a wrapper for `Get-VSTeamClassificationNode` and will retrieve iteration nodes. If you need to retrieve areas or other classification nodes, you should use the `Get-VSTeamClassificationNode` function directly. Always ensure the correct path and project name are provided to get accurate results.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Get-VSTeamClassificationNode](Get-VSTeamClassificationNode.md)

[Get-VSTeamIteration](Get-VSTeamIteration.md)
