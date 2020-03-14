


# Update-VSTeamServiceEndpoint

## SYNOPSIS

Updates an existing service connection

## SYNTAX

## DESCRIPTION

Updates an existing service connection

## EXAMPLES

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 0
Required: True
Accept pipeline input: true (ByPropertyName)
```

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

### -Force

Forces the function without confirmation

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
```

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

