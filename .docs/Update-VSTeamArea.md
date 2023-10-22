<!-- #include "./common/header.md" -->

# Update-VSTeamArea

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamArea.md" -->

## SYNTAX

## EXAMPLES

### Example 1

```powershell
Update-VSTeamArea -ProjectName Demo -Name "NewAreaName" -Path "MyArea/Path"
```

This command updates an area with the specified path to the name NewAreaName (which will change the path) in the Demo project.

### Example 2

```powershell
Update-VSTeamArea -Name "NewAreaName" -Path "MyArea/Path"
```

This command updates an area with the specified path to the name NewAreaName (which will change the path) in the default project.

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamArea.md" -->

## PARAMETERS

### Name

New name of the existing area.

```yaml
Type: string
Required: False
```

### Path

Path of the existing area for which the name will be changed.

```yaml
Type: string
Required: True
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

This function is a wrapper of the base function Add-VSTeamClassificationNode.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Add-VSTeamClassificationNode](Add-VSTeamClassificationNode.md)

[Add-VSTeamIteration](Add-VSTeamIteration.md)

[Update-VSTeamClassificationNode](Update-VSTeamClassificationNode.md)

[Update-VSTeamIteration](Update-VSTeamIteration.md)
