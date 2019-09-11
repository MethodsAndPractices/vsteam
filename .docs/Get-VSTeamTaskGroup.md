<!-- #include "./common/header.md" -->

# Get-VSTeamTaskGroup

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamTaskGroup.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamTaskGroup.md" -->

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

<!-- #include "./params/projectName.md" -->

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