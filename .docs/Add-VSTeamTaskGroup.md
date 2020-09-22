<!-- #include "./common/header.md" -->

# Add-VSTeamTaskGroup

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamTaskGroup.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamTaskGroup.md" -->

## EXAMPLES

### Example 1

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


### InFile

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

### Body

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

<!-- #include "./params/projectName.md" -->

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Update-VSTeamTaskGroup](Update-VSTeamTaskGroup.md)

[Get-VSTeamTaskGroup](Get-VSTeamTaskGroup.md)

[Remove-VSTeamTaskGroup](Remove-VSTeamTaskGroup.md)
