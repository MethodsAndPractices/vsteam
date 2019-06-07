<!-- #include "./common/header.md" -->

# Show-VSTeamReleaseDefinition

## SYNOPSIS

<!-- #include "./synopsis/Show-VSTeamReleaseDefinition.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Show-VSTeamReleaseDefinition.md" -->

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Show-VSTeamReleaseDefinition -ProjectName Demo
```

This command will open a web browser with All Release Definitions for this project showing.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Id

Specifies release definition by ID.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases: ReleaseDefinitionID
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

### Team.ReleaseDefinition

## NOTES

You can pipe the release definition ID to this function.

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamReleaseDefinition](Add-VSTeamReleaseDefinition.md)

[Remove-VSTeamReleaseDefinition](Remove-VSTeamReleaseDefinition.md)
