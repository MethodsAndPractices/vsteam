


# Stop-VSTeamBuild

## SYNOPSIS

Allows you to cancel a running build.

## SYNTAX

## DESCRIPTION

Stop-VSTeamBuild will cancel a build using the build id.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Set-VSTeamDefaultProject Demo
PS C:\> Stop-VSTeamBuild -id 1
```

This example cancels the build with build id 1.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Set-VSTeamDefaultProject Demo
PS C:\> $buildsToCancel = Get-VSTeamBuild -StatusFilter "inProgress" | where-object definitionName -eq Build-Defenition-Name
PS C:\> ForEach($build in $buildsToCancel) { Stop-VSTeamBuild -id $build.id }
```

This example will find all builds with a status of "inProgress" and a defenitionName of "Build-Defenition-Name" and then cancel each of these builds.

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

The id of the build.

```yaml
Type: Int32
Aliases: BuildID
Required: True
Accept pipeline input: true (ByPropertyName, ByValue)
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

### System.String

ProjectName

### System.Int32

BuildId

## OUTPUTS

## NOTES

## RELATED LINKS

