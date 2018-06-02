#include "./common/header.md"

# Add-VSTeamKubernetesEndpoint

## SYNOPSIS
#include "./synopsis/Add-VSTeamKubernetesEndpoint.md"

## SYNTAX

### Plain
```
Add-VSTeamKubernetesEndpoint [-ProjectName] <String> [-Kubeconfig] <String> [-KubernetesUrl] <String> [-ClientCertificateData] <String> [-ClientKeyData] <String> [-AcceptUntrustedCerts] [-GeneratePfx]
 [[-EndpointName] <String>]
```

## DESCRIPTION
The cmdlet adds a new connection between TFS/VSTS and a Kubernetes cluster using kubeconfig json. 

This is only used when using the Kubernetes tasks.

## EXAMPLES

## PARAMETERS

### -Kubeconfig
kubeconfig as JSON string

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -KubernetesUrl
URL of Kubernetes cluster

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -EndpointName
The name displayed on the services page. 
In VSTS this is the Connection Name.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```


### -ClientCertificateData
Client certificate from Kubeconfig

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientKeyData
Client private key from Kubeconfig

```yaml
Type: String
Parameter Sets: Plain
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AcceptUntrustedCerts
Accept untrusted certificates for cluster

```yaml
Type: Switch
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GeneratePfx
Generate pfx file

```yaml
Type: Switch
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#include "./params/projectName.md"

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

