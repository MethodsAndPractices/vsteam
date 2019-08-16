


# Remove-VSTeamRelease

## SYNOPSIS

Removes the releases for a team project.

## SYNTAX

## DESCRIPTION

The Remove-VSTeamRelease function removes the releases for a team project.

The project name is a Dynamic Parameter which may not be displayed in the syntax above but is mandatory.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamRelease -ProjectName demo | Remove-VSTeamRelease
```

This command gets a list of all releases in the demo project.

The pipeline operator (|) passes the data to the Remove-VSTeamRelease function, which removes each release definition object.

## PARAMETERS

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

### -Id

Specifies one or more releases by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release definition, type Get-VSTeamRelease.

```yaml
Type: Int32[]
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -Force

Forces the function without confirmation

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
```

## INPUTS

## OUTPUTS

### None

## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the project for which this function gets releases.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have to pass the ProjectName with each call.

You can pipe release definition IDs to this function.

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamRelease](Add-VSTeamRelease.md)

[Get-VSTeamRelease](Get-VSTeamRelease.md)

