<!-- #include "./common/header.md" -->

# Add-VSTeamClassificationNode

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamClassificationNode.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamClassificationNode.md" -->

## EXAMPLES

### Example 1

```powershell
Add-VSTeamClassificationNode -ProjectName Demo -Name "NewIteration" -StructureGroup "iteration" -Path "MyIteration/Path"
```

This command adds a new iteration named NewIteration to the Demo project under the iteration path MyIteration/Path.

### Example 2

```powershell
Add-VSTeamClassificationNode -ProjectName "Demo" -FinishDate (Get-Date "31.01.2020") -StartDate (Get-Date "01.01.2020") -Name "NewIteration" -StructureGroup "iterations"
```

This command adds a new iteration named NewIteration to the Demo project with the start date 01.01.2020 and finish date 31.01.2020.

## PARAMETERS

### Name

Name of the new classification node.

```yaml
Type: string
Required: True
```

### StructureGroup

Structure group of the classification node.

```yaml
Type: string
Required: True
Accepted values: iterations, areas
```

### Path

Path of the classification node.

```yaml
Type: string
Required: False
```

### StartDate

Start date of the iteration.

```yaml
Type: datetime
Required: False
```

### FinishDate

Finish date of the iteration.

```yaml
Type: datetime
Required: False
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

This function is the base function for Add-VSTeamArea and Add-VSTeamIteration.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamArea](Add-VSTeamArea.md)

[Add-VSTeamIteration](Add-VSTeamIteration.md)
