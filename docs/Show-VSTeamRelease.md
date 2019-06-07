


# Show-VSTeamRelease

## SYNOPSIS

Opens the release summary in the default browser.

## SYNTAX

## DESCRIPTION

Opens the release summary in the default browser.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Show-VSTeamRelease -ProjectName Demo -Id 3
```

This command will open a web browser with the summary of release 3.

## PARAMETERS

### -Id

Specifies release by ID.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases: ReleaseID
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

### Team.Release

## NOTES

You can pipe the release ID to this function.

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamRelease](Add-VSTeamRelease.md)

[Remove-VSTeamRelease](Remove-VSTeamRelease.md)

