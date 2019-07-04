


# Add-VSTeamBuildTag

## SYNOPSIS

Adds a tag to a build.

## SYNTAX

## DESCRIPTION

Adds a tag to a build.

## EXAMPLES

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

### -Tags

One or more tags. To specify multiple, use commas to separate.

```yaml
Type: String[]
Required: True
Position: 1
Accept pipeline input: true (ByPropertyName, ByValue)
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Aliases: cf
```

### -Force

Forces the command without confirmation

```yaml
Type: SwitchParameter
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Aliases: wi
```

## INPUTS

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

