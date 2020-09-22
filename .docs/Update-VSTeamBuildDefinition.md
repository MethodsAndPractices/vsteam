<!-- #include "./common/header.md" -->

# Update-VSTeamBuildDefinition

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamBuildDefinition.md" -->

## SYNTAX

## DESCRIPTION

Reads a JSON file off disk or string and uses that file to update an existing build definition in the provided project.

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### Example 1

```powershell
Update-VSTeamBuildDefinition -ProjectName Demo -Id 123 -InFile build.json
```

This command reads build.json and updates existing build definition with
id 123 from it on the demo team project.

### Example 2

```powershell
$b = Get-VSTeamBuildDefinition -ProjectName Demo -Id 23 -Raw
$b.variables.subscriptionId.value = 'Some New Value'
$body = $b | ConvertTo-Json -Depth 100
Update-VSTeamBuildDefinition -ProjectName Demo -Id 23 -BuildDefinition $body
```

## PARAMETERS

### Id

Specifies the build definition to update by ID.

To find the ID of a build definition, type Get-VSTeamBuildDefinition.

```yaml
Type: Int32
Required: True
Accept pipeline input: true (ByPropertyName)
```

### InFile

Path and file name to the JSON file that contains the definition to be updated. If the path is omitted, the default is the current location.

```yaml
Type: String
Required: True
Parameter Sets: File
Position: 1
Accept pipeline input: true (ByPropertyName)
```

### BuildDefinition

JSON string of build definition.

```yaml
Type: String
Required: True
Parameter Sets: JSON
Position: 1
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### None

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
