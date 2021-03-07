<!-- #include "./common/header.md" -->

# Remove-VSTeamTaskGroup

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamTaskGroup.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamTaskGroup.md" -->

## EXAMPLES

### Example 1

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

### Id

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

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

### System.String[]

System.String

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamTaskGroup](Add-VSTeamTaskGroup.md)

[Get-VSTeamTaskGroup](Get-VSTeamTaskGroup.md)

[Update-VSTeamTaskGroup](Update-VSTeamTaskGroup.md)
