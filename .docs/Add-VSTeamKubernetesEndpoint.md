<!-- #include "./common/header.md" -->

# Add-VSTeamKubernetesEndpoint

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamKubernetesEndpoint.md" -->

## SYNTAX

## DESCRIPTION

The cmdlet adds a new connection between TFS/AzD and a Kubernetes cluster using kubeconfig json.

This is only used when using the Kubernetes tasks.

## EXAMPLES

### Example 1

```powershell
$kubeconfig = Get-Content -Path "C:\path\to\kubeconfig.json" -Raw
Add-VSTeamKubernetesEndpoint -Kubeconfig $kubeconfig -KubernetesUrl "https://k8s-cluster.example.com:6443" -EndpointName "MyK8sCluster" -ClientCertificateData "CERTIFICATE_DATA" -ClientKeyData "KEY_DATA" -AcceptUntrustedCerts -GeneratePfx -ProjectName "WebAppProject"
```

This command creates a new connection to a Kubernetes cluster using the provided kubeconfig file and details. The connection is named "MyK8sCluster" and is associated with the "WebAppProject". It accepts untrusted certificates and generates a pfx file.

### Example 2

```powershell
$kubeconfig = Get-Content -Path "C:\path\to\another\kubeconfig.json" -Raw
Add-VSTeamKubernetesEndpoint -Kubeconfig $kubeconfig -KubernetesUrl "https://another-k8s-cluster.example.org:6443" -EndpointName "AnotherK8sCluster" -ClientCertificateData "ANOTHER_CERTIFICATE_DATA" -ClientKeyData "ANOTHER_KEY_DATA" -ProjectName "BackendServices"
```

Here, a new Kubernetes connection named "AnotherK8sCluster" is created for the "BackendServices" project using the provided kubeconfig file and details.

### Example 3

```powershell
$kubeconfig = Get-Content -Path "C:\path\to\third\kubeconfig.json" -Raw
Add-VSTeamKubernetesEndpoint -Kubeconfig $kubeconfig -KubernetesUrl "https://third-k8s-cluster.example.net:6443" -EndpointName "ThirdK8sCluster" -ClientCertificateData "THIRD_CERTIFICATE_DATA" -ClientKeyData "THIRD_KEY_DATA" -GeneratePfx -ProjectName "DataAnalytics"
```

In this example, a connection to a third Kubernetes cluster is created with the name "ThirdK8sCluster" for the "DataAnalytics" project. It uses the provided kubeconfig file and details and generates a pfx file.

### Example 4

```powershell
$kubeconfig = Get-Content -Path "C:\path\to\fourth\kubeconfig.yaml" -Raw
Add-VSTeamKubernetesEndpoint -Kubeconfig $kubeconfig -KubernetesUrl "https://fourth-k8s-cluster.example.io:6443" -EndpointName "FourthK8sCluster" -ClientCertificateData "FOURTH_CERTIFICATE_DATA" -ClientKeyData "FOURTH_KEY_DATA" -AcceptUntrustedCerts -ProjectName "MobileApp"
```

This command creates a new Kubernetes connection named "FourthK8sCluster" for the "MobileApp" project. It uses the provided kubeconfig file, details, and accepts untrusted certificates.

### Example 5

```powershell
$kubeconfig = Get-Content -Path "C:\path\to\fifth\kubeconfig.yaml" -Raw
Add-VSTeamKubernetesEndpoint -Kubeconfig $kubeconfig -KubernetesUrl "https://fifth-k8s-cluster.example.co:6443" -EndpointName "FifthK8sCluster" -ClientCertificateData "FIFTH_CERTIFICATE_DATA" -ClientKeyData "FIFTH_KEY_DATA" -ProjectName "FrontendUI"
```

This example demonstrates the creation of a new Kubernetes connection named "FifthK8sCluster" for the "FrontendUI" project using the provided kubeconfig file and details.

## PARAMETERS

### Kubeconfig

kubeconfig as JSON string

```yaml
Type: String
Required: True
Accept pipeline input: true (ByPropertyName)
```

### KubernetesUrl

URL of Kubernetes cluster

```yaml
Type: String
Required: True
Accept pipeline input: true (ByPropertyName)
```

### EndpointName

The name displayed on the services page.
In AzD this is the Connection Name.

```yaml
Type: String
Position: 3
```

### ClientCertificateData

Client certificate from Kubeconfig

```yaml
Type: String
Required: True
```

### ClientKeyData

Client private key from Kubeconfig

```yaml
Type: String
Parameter Sets: Plain
Required: True
```

### AcceptUntrustedCerts

Accept untrusted certificates for cluster

```yaml
Type: Switch
```

### GeneratePfx

Generate pfx file

```yaml
Type: Switch
```

<!-- #include "./params/projectName.md" -->

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Get-VSTeamServiceEndpoint](Get-VSTeamServiceEndpoint.md)

[Get-VSTeamServiceEndpointType](Get-VSTeamServiceEndpointType.md)

[Remove-VSTeamServiceEndpoint](Remove-VSTeamServiceEndpoint.md)
