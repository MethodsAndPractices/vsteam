


# Remove-VSTeamBuild

## SYNOPSIS

Deletes the build.

## SYNTAX

## DESCRIPTION

Deletes the build.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuild | Remove-VSTeamBuild -Force
```

This command will delete all builds that are not marked retain indefinitely.

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

Specifies one or more builds by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a build, type Get-VSTeamBuild.

```yaml
Type: Int32[]
Aliases: BuildID
Accept pipeline input: true (ByPropertyName, ByValue)
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

### System.Object

## NOTES

## RELATED LINKS

