<!-- #include "./common/header.md" -->

# Get-VSTeamServiceEndpoint

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamServiceEndpoint.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamServiceEndpoint.md" -->

## EXAMPLES

### Example 1
```powershell
Get-VSTeamServiceEndpoint
```

Returns all available service endpoint types.

### Example 2
```powershell
Get-VSTeamServiceEndpoint -Type "AzureRM"
```

Returns the service endpoint type with the name "AzureRM".

### Example 3
```powershell
Get-VSTeamServiceEndpoint -Scheme "OAuth"
```

Returns service endpoint types that use the "OAuth" scheme.

### Example 4
```powershell
Get-VSTeamServiceEndpoint -Type "GitHub" -Scheme "PersonalAccessToken"
```

Returns the service endpoint type with the name "GitHub" and scheme "PersonalAccessToken".

## PARAMETERS

### Id

Id of the service endpoint

```yaml
Type: String
Parameter Sets: ByID
Required: True
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/projectName.md" -->

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
