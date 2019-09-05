<!-- #include "./common/header.md" -->

# Add-VSTeamServiceFabricEndpoint

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamServiceFabricEndpoint.md" -->

## SYNTAX

## DESCRIPTION

The cmdlet adds a new Service Fabric service endpoint to an existing project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Add-VSTeamServiceFabricEndpoint -ProjectName "SomeProjectName" -endpointName "NoAuthTest" -url "tcp://10.0.0.1:19000" -useWindowsSecurity $false
```

Adds a Service Fabric Endpoint for a non-secure cluster

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> $password = '00000000-0000-0000-0000-000000000000' | ConvertTo-SecureString -AsPlainText -Force
PS C:\> Add-VSTeamServiceFabricEndpoint -ProjectName "SomeProjectName" -endpointName "AzureAdAuthTest" -url "tcp://10.0.0.1:19000" -serverCertThumbprint "SOMECERTTHUMBPRINT" -username "someUser@someplace.com" -password $password
```

Adds a Service Fabric Endpoint for an Azure AD secured cluster.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> $password = '00000000-0000-0000-0000-000000000000' | ConvertTo-SecureString -AsPlainText -Force
PS C:\> $pathToPFX = "C:\someFolder\theCertificateFile.pfx"
PS C:\> $base64Cert = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($pathToPFX))
PS C:\> Add-VSTeamServiceFabricEndpoint -ProjectName "SomeProjectName" -endpointName "CertificateAuthTest" -url "tcp://10.0.0.1:19000" -serverCertThumbprint "SOMECERTTHUMBPRINT" -certificate $base64Cert -certificatePassword $password
```

Adds a Service Fabric Endpoint for a certificate secured cluster.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -url

The url of the Service Fabric management endpoint.

```yaml
Type: String
Required: True
Position: 1
Accept pipeline input: true (ByPropertyName)
```

### -useWindowsSecurity

If windows integrated authentication should be enabled. If set to false, all authentication is disabled.

```yaml
Type: Boolean
Position: 2
Accept pipeline input: true (ByPropertyName)
```

### -clusterSpn

Specify the cluster service principal name, for use with windows integrated authentication.

```yaml
Type: String
Accept pipeline input: true (ByPropertyName)
```

### -serverCertThumbprint

The server certificate thumbprint, used for communicating with the Service Fabric cluster.

```yaml
Type: String
Parameter Sets: AzureAd, Certificate
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -username

The Azure AD Username, used for communicating with the Service Fabric cluster.

```yaml
Type: String
Parameter Sets: AzureAd
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -password

The Password for the Azure AD User, used for communicating with the Service Fabric cluster.

```yaml
Type: SecureString
Parameter Sets: AzureAd
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -certificate

The certificate used for communicating with the Service Fabric cluster.

```yaml
Type: String
Parameter Sets: Certificate
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -certificatePassword

The Password for the certificate used for communicating with the Service Fabric cluster.

```yaml
Type: SecureString
Parameter Sets: Certificate
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -endpointName

The name displayed on the services page. In AzD this is the Connection Name.

```yaml
Type: String
Aliases: displayName
Position: 3
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

### Team.ServiceEndpoint

## NOTES

## RELATED LINKS

[Get-VSTeamServiceEndpoint](Get-VSTeamServiceEndpoint.md)

[Get-VSTeamServiceEndpointType](Get-VSTeamServiceEndpointType.md)

[Remove-VSTeamServiceEndpoint](Remove-VSTeamServiceEndpoint.md)
