<!-- #include "./common/header.md" -->

# Update-VSTeamBuildDefinition

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamBuildDefinition.md" -->

## SYNTAX

## DESCRIPTION

Reads a JSON file off disk and uses that file to update an existing
build defintion in the provided project.

You must call Add-VSTeamAccount before calling this function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Update-VSTeamBuildDefinition -ProjectName Demo -Id 123 -InFile build.json
```

This command reads build.json and updates existing build defintion with
id 123 from it on the demo team project.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Id

Specifies the build definition to update by ID.

To find the ID of a build defintion, type Get-VSTeamBuildDefinition.

```yaml
Type: Int32
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -InFile

Path and file name to the JSON file that contains the defintion to be updated. If the path is omitted, the default is the current location.

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