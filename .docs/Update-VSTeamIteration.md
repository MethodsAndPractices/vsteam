<!-- #include "./common/header.md" -->

# Update-VSTeamIteration

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamIteration.md" -->

## SYNTAX

## EXAMPLES

### Example 1

```powershell
Update-VSTeamIteration -ProjectName Demo -Name "NewIterationName" -Path "MyIteration/Path"
```

This command updates an iteration with the specified path to the name NewIterationName (which will change the path) in the Demo project. Additionally, because no dates are specified, if any dates did previously exist, they would be "unset."

### Example 2

```powershell
Update-VSTeamArea -Name "NewIterationName" -Path "MyIteration/Path" -FinishDate "31.01.2020" -StartDate "01.01.2020"
```

This command updates an area with the specified path to the name NewIterationName (which will change the path) in the default project with the start date 01.01.2020 and finish date 31.01.2020.

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamIteration.md" -->

## PARAMETERS

### Name

New name of the iteration.

```yaml
Type: string
Required: False
```

### Path

Path of the existing iteration that will be updated.

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
Required: false
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

This function is a wrapper of the base function Update-VSTeamClassificationNode.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

[Add-VSTeamArea](Add-VSTeamArea.md)

[Add-VSTeamClassificationNode](Add-VSTeamClassificationNode.md)

[Update-VSTeamArea](Update-VSTeamArea.md)

[Update-VSTeamClassificationNode](Update-VSTeamClassificationNode.md)
