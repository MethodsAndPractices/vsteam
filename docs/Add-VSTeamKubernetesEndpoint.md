


# Add-VSTeamKubernetesEndpoint

## SYNOPSIS

Adds connections to Kubernetes clusters

## SYNTAX

## DESCRIPTION

The cmdlet adds a new connection between TFS/AzD and a Kubernetes cluster using kubeconfig json.

This is only used when using the Kubernetes tasks.

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

### -Kubeconfig

kubeconfig as JSON string

```yaml
Type: String
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -KubernetesUrl

URL of Kubernetes cluster

```yaml
Type: String
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -EndpointName

The name displayed on the services page.
In AzD this is the Connection Name.

```yaml
Type: String
Position: 3
```

### -ClientCertificateData

Client certificate from Kubeconfig

```yaml
Type: String
Required: True
```

### -ClientKeyData

Client private key from Kubeconfig

```yaml
Type: String
Parameter Sets: Plain
Required: True
```

### -AcceptUntrustedCerts

Accept untrusted certificates for cluster

```yaml
Type: Switch
```

### -GeneratePfx

Generate pfx file

```yaml
Type: Switch
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Get-VSTeamServiceEndpoint](Get-VSTeamServiceEndpoint.md)

[Get-VSTeamServiceEndpointType](Get-VSTeamServiceEndpointType.md)

[Remove-VSTeamServiceEndpoint](Remove-VSTeamServiceEndpoint.md)

