#include "./common/header.md"

# Show-VSTeamApproval

## SYNOPSIS
#include "./synopsis/Show-VSTeamApproval.md"

## SYNTAX

```
Show-VSTeamApproval [-ProjectName] <String> [-ReleaseDefinitionId] <Int32>
```

## DESCRIPTION
#include "./synopsis/Show-VSTeamApproval.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-VSTeamApproval -ProjectName Demo | Show-VSTeamApproval
```

This command opens a web browser showing the release requiring approval.

## PARAMETERS

### -ReleaseDefinitionId
Only approvals for the release id provided will be returned

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Id

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

#include "./params/projectName.md"

## INPUTS

### You can pipe build defintion IDs to this function.

## OUTPUTS

### Team.BuildDefinition

## NOTES
This function has a Dynamic Parameter for ProjectName that specifies the
project for which this function gets build definitions.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)
[Add-VSTeamBuildDefinition](Add-VSTeamBuildDefinition.md)
[Remove-VSTeamBuildDefinition](Remove-VSTeamBuildDefinition.md)