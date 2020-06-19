


# Add-VSTeamArea

## SYNOPSIS

Adds a new area to the project

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

Adds a new area to the project

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 0
Required: True
Accept pipeline input: true (ByPropertyName)
```

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

