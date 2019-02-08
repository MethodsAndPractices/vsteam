


# Update-VSTeamBuildDefinition

## SYNOPSIS

Updates a build definition for a team project.

## SYNTAX

## DESCRIPTION

Reads a JSON file off disk and uses that file to update an existing build definition in the provided project.

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Update-VSTeamBuildDefinition -ProjectName Demo -Id 123 -InFile build.json
```

This command reads build.json and updates existing build definition with
id 123 from it on the demo team project.

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Required: true
Position: 0
Accept pipeline input: true (ByPropertyName)
```

### -Id

Specifies the build definition to update by ID.

To find the ID of a build definition, type Get-VSTeamBuildDefinition.

```yaml
Type: Int32
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -InFile

Path and file name to the JSON file that contains the definition to be updated. If the path is omitted, the default is the current location.

```yaml
Type: String
Required: True
Position: 1
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

### None

## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the project for which this function gets build definitions.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have to pass the ProjectName with each call.

## RELATED LINKS
