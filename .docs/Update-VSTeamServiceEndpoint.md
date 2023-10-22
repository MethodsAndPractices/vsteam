<!-- #include "./common/header.md" -->

# Update-VSTeamServiceEndpoint

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamServiceEndpoint.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamServiceEndpoint.md" -->

## EXAMPLES

### Example 1
```powershell
$endpointPayload = @{
    name     = "MyNewEndpoint";
    type     = "generic";
    url      = "https://api.endpoint.com";
    isShared = $false
}

Update-VSTeamServiceEndpoint -Id "12345678-abcd-1234-abcd-1234567890ab" -Object $endpointPayload
```

Updates the service endpoint with ID `12345678-abcd-1234-abcd-1234567890ab` with the specified properties in the `$endpointPayload` hashtable.

### Example 2
```powershell
$endpointPayload = @{
    name     = "MyNewEndpoint";
    type     = "generic";
    url      = "https://api.endpoint.com";
    isShared = $false
}

Update-VSTeamServiceEndpoint -Id "12345678-abcd-1234-abcd-1234567890ab" -Object $endpointPayload -ProjectName "MyProject"
```

Updates the service endpoint within the "MyProject" project with ID `12345678-abcd-1234-abcd-1234567890ab` with the specified properties in the `$endpointPayload` hashtable.

### Example 3
```powershell
$endpointPayload = @{
    name     = "MyNewEndpoint";
    type     = "generic";
    url      = "https://api.endpoint.com";
    isShared = $false
}

Update-VSTeamServiceEndpoint -Id "12345678-abcd-1234-abcd-1234567890ab" -Object $endpointPayload -Force
```

Updates the service endpoint with ID `12345678-abcd-1234-abcd-1234567890ab` with the specified properties in the `$endpointPayload` hashtable and forces the update without any confirmation prompts.

## PARAMETERS

### Id

UUID of existing services endpoint from AzD

```yaml
Type: String
Position: 1
```

### Object

Hashtable of payload for REST call

```yaml
Type: Hashtable
Required: true
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

### vsteam_lib.ServiceEndpoint

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Add-VSTeamServiceEndpoint](Add-VSTeamServiceEndpoint.md)

[Add-VSTeamServiceFabricEndpoint](Add-VSTeamServiceFabricEndpoint.md)

[Add-VSTeamSonarQubeEndpoint](Add-VSTeamSonarQubeEndpoint.md)

[Add-VSTeamKubernetesEndpoint](Add-VSTeamKubernetesEndpoint.md)

[Add-VSTeamAzureRMServiceEndpoint](Add-VSTeamAzureRMServiceEndpoint.md)

[Get-VSTeamServiceEndpoint](Get-VSTeamServiceEndpoint.md)

[Get-VSTeamServiceEndpointType](Get-VSTeamServiceEndpointType.md)

[Remove-VSTeamServiceEndpoint](Remove-VSTeamServiceEndpoint.md)
