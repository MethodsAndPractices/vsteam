


# Remove-VSTeamTaskGroup

## SYNOPSIS

Removes a task group

## SYNTAX

## DESCRIPTION

Removes a task group

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```powershell

$projectName = "some_project_name"
$taskGroup = Get-VSTeamTaskGroup -Name "taskName" -ProjectName $projectName

$methodParameters = @{
   Id                       = $taskGroup.id
   ProjectName              = $projectName
   Force                    = $true
}

Remove-VSTeamTaskGroup @methodParameters
```

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

Does not prompt

```yaml
Type: SwitchParameter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id

ID of the existing task group

```yaml
Type: String
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

### System.String[]

System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Add-VSTeamTaskGroup](Add-VSTeamTaskGroup.md)

[Get-VSTeamTaskGroup](Get-VSTeamTaskGroup.md)

[Update-VSTeamTaskGroup](Update-VSTeamTaskGroup.md)

