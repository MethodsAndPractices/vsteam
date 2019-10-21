---
external help file: VSTeam-Help.xml
Module Name: VSTeam
online version:
schema: 2.0.0
---

# Get-VSTeamTaskGroup

## SYNOPSIS

Gets a task group

## SYNTAX

## DESCRIPTION

Gets a task group

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```powershell

$methodParameters = @{
   ProjectName = "some_project_name"
}

Get-VSTeamTaskGroup @methodParameters
```

### -------------------------- EXAMPLE 2 --------------------------

```powershell

$methodParameters = @{
   ProjectName = "some_project_name"
   Id          = "Task_group_id"
}

Get-VSTeamTaskGroup @methodParameters
```

### -------------------------- EXAMPLE 3 --------------------------

```powershell

$methodParameters = @{
   ProjectName = "some_project_name"
   Name        = "Task_group_name"
}

Get-VSTeamTaskGroup @methodParameters
```

## PARAMETERS

### -ProjectName

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

### -Id

ID of the existing task group

### -Name

Name of the existing task group

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorTask, -InformationAction, -InformationTask, -OutTask, -OutBuffer, -PipelineTask, -Verbose, -WarningAction, and -WarningTask.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Add-VSTeamTaskGroup](Add-VSTeamTaskGroup.md)

[Update-VSTeamTaskGroup](Update-VSTeamTaskGroup.md)

[Remove-VSTeamTaskGroup](Remove-VSTeamTaskGroup.md)
