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

Get all the task groups for the some_project_name project.  Here we are splatting the parameter, but it may also be directly specified.  See a non-splatting example below.

### -------------------------- EXAMPLE 2 --------------------------

```powershell
Get-VSTeamTaskGroup -ProjectName "some_project_name" -Id "Task_group_id"
```

Get a task group when the ID is already known.

### -------------------------- EXAMPLE 3 --------------------------

```powershell

$methodParameters = @{
   ProjectName = "some_project_name"
   Name        = "Task_group_name"
}

Get-VSTeamTaskGroup @methodParameters
```

Get a task group by name, when the ID is not known.  Here we are splatting the parameters, but they may also be directly specified.  Getting by ID is preferred, as it's more efficient; but getting by name is, of course, handy.

## PARAMETERS

### -ProjectName

<!-- #include "./params/projectName.md" -->

### -Id

ID of the existing task group

```yaml
Type: String
Parameter Sets: ByID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name

Name of the existing task group

```yaml
Type: String
Parameter Sets: ByName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

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