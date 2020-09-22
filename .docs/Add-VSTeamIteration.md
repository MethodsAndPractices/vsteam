<!-- #include "./common/header.md" -->

# Add-VSTeamIteration

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamIteration.md" -->

## SYNTAX

## EXAMPLES

### Example 1

```powershell
Add-VSTeamIteration -ProjectName Demo -Name "NewIteration" -Path "MyIteration/Path"
```

This command adds a new iteration named NewIteration to the Demo project under the iteration path MyIteration/Path.

### Example 2

```powershell
Add-VSTeamIteration -ProjectName "Demo" -FinishDate "31.01.2020" -StartDate "01.01.2020" -Name "NewIteration"
```

This command adds a new iteration named NewIteration to the Demo project with the start date 01.01.2020 and finish date 31.01.2020.

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamIteration.md" -->

## PARAMETERS

### Name

Name of the new iteration.

```yaml
Type: string
Required: True
```

### Path

Path of the existing iteration under where the new one will be created.

```yaml
Type: string
Required: True
```

### StartDate

Start date of the iteration.

```yaml
Type: datetime
```

### FinishDate

Finish date of the iteration.

```yaml
Type: datetime
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

This function is a wrapper of the base function Add-VSTeamClassificationNode.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamArea](Add-VSTeamArea.md)

[Add-VSTeamClassificationNode](Add-VSTeamClassificationNode.md)
