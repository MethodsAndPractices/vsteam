<!-- #include "./common/header.md" -->

# Show-VSTeamApproval

## SYNOPSIS

<!-- #include "./synopsis/Show-VSTeamApproval.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Show-VSTeamApproval.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamApproval -ProjectName Demo | Show-VSTeamApproval
```

This command opens a web browser showing the release requiring approval.

## PARAMETERS

### ReleaseDefinitionId

Only approvals for the release id provided will be returned.

```yaml
Type: Int32
Aliases: Id
Required: True
Position: 1
Accept pipeline input: true (ByPropertyName, ByValue)
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### vsteam_lib.BuildDefinition

## NOTES

You can pipe build definition IDs to this function.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamBuildDefinition](Add-VSTeamBuildDefinition.md)

[Remove-VSTeamBuildDefinition](Remove-VSTeamBuildDefinition.md)
