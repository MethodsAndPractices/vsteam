<!-- #include "./common/header.md" -->

# Add-VSTeamBuildDefinition

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamBuildDefinition.md" -->

## SYNTAX

## DESCRIPTION

Reads a JSON file off disk and uses that file to create a new build definition in the provided project.

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### Example 1

```powershell
Add-VSTeamBuildDefinition -ProjectName Demo -InFile build.json
```

This command reads build.json and creates a new build definition from it
on the demo team project.

## PARAMETERS

### InFile

Path and file name to the JSON file that contains the definition to be created. If the path is omitted, the default is the current location.

```yaml
Type: String
Required: True
Position: 1
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/projectName.md" -->

## INPUTS

### System.String

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
