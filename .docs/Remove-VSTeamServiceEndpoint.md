<!-- #include "./common/header.md" -->

# Remove-VSTeamServiceEndpoint

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamServiceEndpoint.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamServiceEndpoint.md" -->

## EXAMPLES

### Example 1
```powershell
Remove-VSTeamServiceEndpoint -Id "12345678-abcd-1234-abcd-1234567890ab"
```

Removes the service endpoint with ID `12345678-abcd-1234-abcd-1234567890ab`.

### Example 2
```powershell
Remove-VSTeamServiceEndpoint -Id "12345678-abcd-1234-abcd-1234567890ab" -ProjectName "MyProject"
```

Removes the service endpoint with ID `12345678-abcd-1234-abcd-1234567890ab` within the "MyProject" project.

### Example 3
```powershell
Remove-VSTeamServiceEndpoint -Id "12345678-abcd-1234-abcd-1234567890ab" -Force
```

Removes the service endpoint with ID `12345678-abcd-1234-abcd-1234567890ab` and forces the removal without any confirmation prompts.

## PARAMETERS

### Id

Id of the service endpoint

```yaml
Type: String[]
Required: True
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
