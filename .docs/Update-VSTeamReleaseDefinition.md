<!-- #include "./common/header.md" -->

# Update-VSTeamReleaseDefinition

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamReleaseDefinition.md" -->

## SYNTAX

## DESCRIPTION

Reads a JSON file off disk or from string and uses that file to update an existing release definition in the provided project.

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Update-VSTeamReleaseDefinition -ProjectName Demo -Id 123 -InFile release.json
```

This command reads release.json and updates existing release definition with
id 123 from it on the demo team project.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> $b = Get-VSTeamReleaseDefinition -ProjectName Demo -Id 23 -Raw
PS C:\> $b.variables.subscriptionId.value = 'Some New Value'
PS C:\> $body = $b | ConvertTo-Json -Depth 100
PS C:\> Update-VSTeamReleaseDefinition -ProjectName Demo -ReleaseDefinition $body
```

This commands update the variables of the release definition.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -InFile

Path and file name to the JSON file that contains the definition to be updated. If the path is omitted, the default is the current location.

```yaml
Type: String
Required: true
Parameter Sets: File
Position: 1
Accept pipeline input: true (ByPropertyName)
```

### -ReleaseDefinition

JSON string of release definition.

```yaml
Type: String
Required: true 
Parameter Sets: JSON
Position: 1
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/confirm.md" -->

<!-- #include "./params/force.md" -->

<!-- #include "./params/whatIf.md" -->

## INPUTS

## OUTPUTS

### None

## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the project for which this function gets release definitions.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have to pass the ProjectName with each call.

## RELATED LINKS
