<!-- #include "./common/header.md" -->

# Add-VSTeamArea

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamArea.md" -->

## SYNTAX

## EXAMPLES

### Example 1

```powershell
Add-VSTeamArea -ProjectName Demo -Name "NewArea" -Path "MyArea/Path"
```

This command adds a new area named NewArea to the Demo project under the area path MyArea/Path.

### Example 2

```powershell
Add-VSTeamArea -ProjectName Demo -Name "NewArea"
```

This command adds a new area named NewArea to the Demo project.

### Example 3

```powershell
Add-VSTeamArea "NewArea"
```

This command adds a new area named NewArea to the default project.

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamArea.md" -->

## PARAMETERS

### Name

Name of the new area.

```yaml
Type: string
Position: 0
```

### Path

Path of the existing area under where the new one will be created.

```yaml
Type: string
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

[Add-VSTeamClassificationNode](Add-VSTeamClassificationNode.md)

[Add-VSTeamIteration](Add-VSTeamIteration.md)
