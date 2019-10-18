<!-- #include "./common/header.md" -->

# Update-VSTeamServiceEndpoint

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamServiceEndpoint.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamServiceEndpoint.md" -->

## EXAMPLES

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Id

UUID of existing services endpoint from AzD

```yaml
Type: String
Position: 1
```

### -Object

Hashtable of payload for REST call

```yaml
Type: Hashtable
Required: true
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/force.md" -->

## INPUTS

## OUTPUTS

### Team.ServiceEndpoint

## NOTES

## RELATED LINKS

[Add-VSTeamServiceEndpoint](Add-VSTeamServiceEndpoint.md)

[Add-VSTeamServiceFabricEndpoint](Add-VSTeamServiceFabricEndpoint.md)

[Add-VSTeamSonarQubeEndpoint](Add-VSTeamSonarQubeEndpoint.md)

[Add-VSTeamKubernetesEndpoint](Add-VSTeamKubernetesEndpoint.md)

[Add-VSTeamAzureRMServiceEndpoint](Add-VSTeamAzureRMServiceEndpoint.md)

[Get-VSTeamServiceEndpoint](Get-VSTeamServiceEndpoint.md)

[Get-VSTeamServiceEndpointType](Get-VSTeamServiceEndpointType.md)

[Remove-VSTeamServiceEndpoint](Remove-VSTeamServiceEndpoint.md)
