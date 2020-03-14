


# Add-VSTeamServiceEndpoint

## SYNOPSIS

Adds a generic service connection

## SYNTAX

## DESCRIPTION

The cmdlet adds a new generic connection between TFS/AzD and a third party service (see AzD for available connections).

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

### -Object

Hashtable of Payload for REST call

```yaml
Type: Hashtable
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -EndpointName

The name displayed on the services page. In AzD this is the Connection Name.

```yaml
Type: String
Position: 2
```

### -EndpointType

Type of endpoint (eg. `kubernetes`, `sonarqube`). See AzD service page for supported endpoints.

```yaml
Type: String
Position: 3
```

## INPUTS

## OUTPUTS

### Team.ServiceEndpoint

## NOTES

## RELATED LINKS

[Get-VSTeamServiceEndpoint](Get-VSTeamServiceEndpoint.md)

[Get-VSTeamServiceEndpointType](Get-VSTeamServiceEndpointType.md)

[Remove-VSTeamServiceEndpoint](Remove-VSTeamServiceEndpoint.md)

