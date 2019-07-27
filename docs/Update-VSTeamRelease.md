


# Update-VSTeamRelease

## SYNOPSIS

Allows you to update release variables for future stages to read.

## SYNTAX

## DESCRIPTION

Allows you to update release variables for future stages to read.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Set-VSTeamAccount -Account mydemos -Token $(System.AccessToken) -UseBearerToken
PS C:\> $r = Get-VSTeamRelease -ProjectName project -Id 76 -Raw
PS C:\> $r.variables.temp.value='temp'
PS C:\> Update-VSTeamRelease -ProjectName project -Id 76 -release $r
```

Changes the variable temp on the release. This can be done in one stage and read in another stage.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Set-VSTeamAccount -Account mydemos -Token $(System.AccessToken) -UseBearerToken
PS C:\> $r = Get-VSTeamRelease -ProjectName project -Id 76 -Raw
PS C:\> $r.variables | Add-Member NoteProperty temp([PSCustomObject]@{value='test'})
PS C:\> Update-VSTeamRelease -ProjectName project -Id 76 -release $r
```

Adds a variable temp to the release with a value of test.

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

The id of the release to update

```yaml
Type: Int32
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -Release

The updated release to save in AzD

```yaml
Type: PSCustomObject
Required: True
```

### -Confirm

Prompts you for confirmation before running the function.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
Aliases: cf
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

### -WhatIf

Shows what would happen if the function runs.
The function is not run.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
Aliases: wi
```

## INPUTS

## OUTPUTS

### Team.Release

## NOTES

## RELATED LINKS

