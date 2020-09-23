<!-- #include "./common/header.md" -->

# Update-VSTeamReleaseDefinition

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamReleaseDefinition.md" -->

## SYNTAX

## DESCRIPTION

Reads a JSON file off disk or from string and uses that file to update an existing release definition in the provided project.

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### Example 1

```powershell
Update-VSTeamReleaseDefinition -ProjectName Demo -Id 123 -InFile release.json
```

This command reads release.json and updates existing release definition with
id 123 from it on the demo team project.

### Example 2

```powershell
$b = Get-VSTeamReleaseDefinition -ProjectName Demo -Id 23 -Raw
$b.variables.subscriptionId.value = 'Some New Value'
$body = $b | ConvertTo-Json -Depth 100
Update-VSTeamReleaseDefinition -ProjectName Demo -ReleaseDefinition $body
```

This commands update the variables of the release definition.

## PARAMETERS

### InFile

Path and file name to the JSON file that contains the definition to be updated. If the path is omitted, the default is the current location.

```yaml
Type: String
Required: true
Parameter Sets: File
Position: 1
Accept pipeline input: true (ByPropertyName)
```

### ReleaseDefinition

JSON string of release definition.

```yaml
Type: String
Required: true
Parameter Sets: JSON
Position: 1
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

### None

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
