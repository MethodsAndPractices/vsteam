


# Show-VSTeamBuild

## SYNOPSIS

Opens the build summary in the default browser.

## SYNTAX

## DESCRIPTION

Opens the build summary in the default browser.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Show-VSTeamBuild -ProjectName Demo -Id 3
```

This command will open a web browser with the summary of build 3.

## PARAMETERS

### -Id

Specifies build by ID.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases: BuildID
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

### Team.Build

## NOTES

You can pipe the build ID to this function.

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamBuild](Add-VSTeamBuild.md)

[Remove-VSTeamBuild](Remove-VSTeamBuild.md)

