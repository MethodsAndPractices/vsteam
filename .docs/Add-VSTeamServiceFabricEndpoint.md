#include "./common/header.md"

# Add-VSTeamServiceFabricEndpoint

## SYNOPSIS
#include "./synopsis/Add-VSTeamServiceFabricEndpoint.md"

## SYNTAX

### None (Default)
```
Add-VSTeamServiceFabricEndpoint [-ProjectName] <String> [-endpointName] <String>  [-url] <String> [-clusterSpn] <String> [-useWindowsSecurity] <Boolean>
```

### AzureAd
```
Add-VSTeamServiceFabricEndpoint [-ProjectName] <String> [-endpointName] <String>  [-url] <String> [-serverCertThumbprint] <String> [-username] <SecureString> [-password] <String>
```

### Certificate
```
Add-VSTeamServiceFabricEndpoint [-ProjectName] <String> [-endpointName] <String>  [-url] <String> [-serverCertThumbprint] <String> [-certificate] <SecureString> [-certificatePassword] <String>
```

## DESCRIPTION
The cmdlet adds a new Service Fabric service endpoint to an existing project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Add-VSTeamServiceFabricEndpoint -ProjectName "SomeProjectName" -endpointName "NoAuthTest" -url "tcp://10.0.0.1:19000" -useWindowsSecurity $false
```

Adds a Service Fabric Endpoint for a non-secure cluster

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> $password = '00000000-0000-0000-0000-000000000000' | ConvertTo-SecureString -AsPlainText -Force
PS C:\> Add-VSTeamServiceFabricEndpoint -ProjectName "SomeProjectName" -endpointName "AzureAdAuthTest" -url "tcp://10.0.0.1:19000" -serverCertThumbprint "SOMECERTTHUMBPRINT" -username "someuser@someplace.com" -password $password
```

Adds a Service Fabric Endpoint for an Azure AD secured cluster.

### -------------------------- EXAMPLE 3 --------------------------
```
PS C:\> $password = '00000000-0000-0000-0000-000000000000' | ConvertTo-SecureString -AsPlainText -Force
PS C:\> $pathToPFX = "C:\someFolder\theCertificateFile.pfx"
PS C:\> $base64Cert = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($pathToPFX))
PS C:\> Add-VSTeamServiceFabricEndpoint -ProjectName "SomeProjectName" -endpointName "CertificateAuthTest" -url "tcp://10.0.0.1:19000" -serverCertThumbprint "SOMECERTTHUMBPRINT" -certificate $base64Cert -certificatePassword $password
```

Adds a Service Fabric Endpoint for a certificate secured cluster.

## PARAMETERS

### -ProjectName
The name of the Project.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -url
The url of the Service Fabric management endpoint.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -useWindowsSecurity
If windows intergrated authentication should be enabled. If set to false, all authentication is disabled.

```yaml
Type: Boolean
Parameter Sets: None (Default)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -clusterSpn
Specify the cluster service principal name, for use with windows intergrated authentication.

```yaml
Type: String
Parameter Sets: None (Default)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -serverCertThumbprint
The server certificate thumbprint, used for communicating with the Service Fabric cluster.

```yaml
Type: String
Parameter Sets: AzureAd, Certificate
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -username
The Azure AD Username, used for communicating with the Service Fabric cluster.

```yaml
Type: String
Parameter Sets: AzureAd
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -password
The Password for the Azure AD User, used for communicating with the Service Fabric cluster.

```yaml
Type: SecureString
Parameter Sets: AzureAd
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -certificate
The certificate used for communicating with the Service Fabric cluster.

```yaml
Type: String
Parameter Sets: Certificate
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -certificatePassword
The Password for the certificate used for communicating with the Service Fabric cluster.

```yaml
Type: SecureString
Parameter Sets: Certificate
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -endpointName
The name displayed on the services page. 
In VSTS this is the Connection Name.

```yaml
Type: String
Parameter Sets: (All)
Aliases: displayName

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

#include "./params/projectName.md"

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS