<!-- #include "./common/header.md" -->

# Add-VSTeamTaskGroup

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamTaskGroup.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamTaskGroup.md" -->

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```powershell

$taskGroup = Get-VSTeamTaskGroup -Name "taskGroupName" -ProjectName "sourceProjectName"

# Set the ID and revision to null, so AzD is happy.
$taskGroup.id = $null
$taskGroup.revision = $null

$taskGroupJson = ConvertTo-Json -InputObject $taskGroup -Depth 10

Add-VSTeamTaskGroup -Body $taskGroupJson -ProjectName "destinationProjectName"
```

This example is useful for when one wants to copy an existing task group in one project into another project.

## PARAMETERS

### -ProjectName

<!-- #include "./params/projectName.md" -->

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

### -InFile

The path to the json file that represents the task group

```yaml
Type: String
Parameter Sets: ByFile
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Body

The json that represents the task group as a string

```yaml
Type: String
Parameter Sets: ByBody
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

[Update-VSTeamTaskGroup](Update-VSTeamTaskGroup.md)

[Get-VSTeamTaskGroup](Get-VSTeamTaskGroup.md)

[Remove-VSTeamTaskGroup](Remove-VSTeamTaskGroup.md)
