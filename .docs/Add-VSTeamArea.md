<!-- #include "./common/header.md" -->

# Add-VSTeamArea

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamArea.md" -->

## SYNTAX

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Add-VSTeamArea -ProjectName Demo -Name "NewArea" -Path "MyArea/Path"
```

This command adds a new area named NewArea to the Demo project under the area path MyArea/Path.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Add-VSTeamArea -ProjectName Demo -Name "NewArea"
```

This command adds a new area named NewArea to the Demo project.

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamArea.md" -->

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Name

Name of the new area.

```yaml
Type: string
```

### -Path

Path of the existing area under where the new one will be created.

```yaml
Type: string
```

## INPUTS

## OUTPUTS

### System.Object

## NOTES

This function is a wrapper of the base function Add-VSTeamClassificationNode.

## RELATED LINKS

[Add-VSTeamClassificationNode](Add-VSTeamClassificationNode.md)

[Add-VSTeamIteration](Add-VSTeamIteration.md)
