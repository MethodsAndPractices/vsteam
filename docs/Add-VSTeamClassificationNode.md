


# Add-VSTeamClassificationNode

## SYNOPSIS

Adds either a new iteration or area to the project

## SYNTAX

## DESCRIPTION

Adds either a new iteration or area to the project

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Add-VSTeamClassificationNode -ProjectName Demo -Name "NewIteration" -StructureGroup "iteration" -Path "MyIteration/Path"
```

This command adds a new iteration named NewIteration to the Demo project under the iteration path MyIteration/Path.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Add-VSTeamClassificationNode -ProjectName "Demo" -FinishDate (Get-Date "31.01.2020") -StartDate (Get-Date "01.01.2020") -Name "NewIteration" -StructureGroup "iterations"
```

This command adds a new iteration named NewIteration to the Demo project with the start date 01.01.2020 and finish date 31.01.2020.

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

Name of the new classification node.

```yaml
Type: string
```

### -StructureGroup

Structure group of the classification node.

```yaml
Type: string
Accepted values: iterations, areas
```

### -Path

Path of the classification node.

```yaml
Type: string
```

### -StartDate

Start date of the classification node.

```yaml
Type: datetime
```

### -FinishDate

Finish date of the classification node.

```yaml
Type: datetime
```

## INPUTS

## OUTPUTS

### System.Object

## NOTES

This function is the base function for Add-VSTeamArea and Add-VSTeamIteration.

## RELATED LINKS

[Add-VSTeamArea](Add-VSTeamArea.md)

[Add-VSTeamIteration](Add-VSTeamIteration.md)

