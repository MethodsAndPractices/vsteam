


# Add-VSTeamBuildDefinition

## SYNOPSIS

Creates a new build definition from a JSON file.

## SYNTAX

## DESCRIPTION

Reads a JSON file off disk and uses that file to create a new build definition in the provided project.

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Add-VSTeamBuildDefinition -ProjectName Demo -InFile build.json
```

This command reads build.json and creates a new build definition from it
on the demo team project.

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

### -InFile

Path and file name to the JSON file that contains the definition to be created. If the path is omitted, the default is the current location.

```yaml
Type: String
Required: True
Position: 1
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

### System.String

## OUTPUTS

## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the
project for which this function gets build definitions.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

