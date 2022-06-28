<!-- #include "./common/header.md" -->

# Update-VSTeamClassificationNode

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamClassificationNode.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamClassificationNode.md" -->

## EXAMPLES

### Example 1

```powershell
Update-VSTeamClassificationNode -ProjectName Demo -Name "NewIteration" -StructureGroup "iterations" -Path "MyIteration/Path"
```

This command updates a pre-existing iteration at the path MyIteration/Path with the new name NewIteration (which will change the path) within the Demo project. Additionally, because no dates are specified, if any dates did previously exist, they would be "unset."

### Example 2

```powershell
Update-VSTeamClassificationNode -ProjectName "Demo" -FinishDate (Get-Date "31.01.2020") -StartDate (Get-Date "01.01.2020") -Name "NewIteration" -StructureGroup "iterations" -Path "MyIteration/Path"
```

This command updates a pre-existing iteration at the path MyIteration/Path with the new name NewIteration (which will change the path), the start date 01.01.2020, and finish date 31.01.2020 within the Demo project.

## PARAMETERS

### Name

New name for the classification node.

```yaml
Type: string
Required: False
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
Required: True
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

This function is the base function for Update-VSTeamArea and Update-VSTeamIteration.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Add-VSTeamArea](Add-VSTeamArea.md)

[Add-VSTeamIteration](Add-VSTeamIteration.md)

[Update-VSTeamArea](Update-VSTeamArea.md)

[Update-VSTeamIteration](Update-VSTeamIteration.md)
