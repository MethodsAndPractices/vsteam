<!-- #include "./common/header.md" -->

# Add-VSTeamServiceEndpoint

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamServiceEndpoint.md" -->

## SYNTAX

## DESCRIPTION

The cmdlet adds a new generic connection between TFS/AzD and a third party service (see AzD for available connections).

## EXAMPLES

### Example 1

```powershell
$payload = @{
    url = "https://api.example.com";
    username = "apiuser";
    password = "apipassword";
}
Add-VSTeamServiceEndpoint -Object $payload -EndpointName "ExampleAPI" -EndpointType "generic" -ProjectName "WebAppProject"
```

This command creates a new generic service connection named "ExampleAPI" for the "WebAppProject" project. The service connection connects to "https://api.example.com" using the username "apiuser" and password "apipassword".

### Example 2

```powershell
$payload = @{
    url = "https://k8s-cluster.example.org";
    token = "k8s-access-token";
}
Add-VSTeamServiceEndpoint -Object $payload -EndpointName "K8sCluster" -EndpointType "kubernetes" -ProjectName "BackendServices"
```

In this example, a new Kubernetes service connection named "K8sCluster" for the "BackendServices" project is created. The service connection connects to the Kubernetes cluster at "https://k8s-cluster.example.org" using the provided token.

### Example 3

```powershell
$payload = @{
    url = "https://sonarqube.example.net";
    token = "sonar-access-token";
}
Add-VSTeamServiceEndpoint -Object $payload -EndpointName "SonarQubeDev" -EndpointType "sonarqube" -ProjectName "FrontendUI"
```

This command sets up a SonarQube service connection named "SonarQubeDev" for the "FrontendUI" project. The SonarQube server's URL is "https://sonarqube.example.net", and it authenticates using the specified token.

### Example 4

```powershell
$payload = @{
    url = "https://db.example.co";
    username = "dbadmin";
    password = "dbpassword";
}
Add-VSTeamServiceEndpoint -Object $payload -EndpointName "DatabaseEndpoint" -EndpointType "generic" -ProjectName "DataServices"
```

Here, a generic service connection named "DatabaseEndpoint" for the "DataServices" project is created. The service connection connects to the database at "https://db.example.co" using the given username and password.

### Example 5

```powershell
$payload = @{
    url = "https://storage.example.com";
    accessKey = "storage-access-key";
}
Add-VSTeamServiceEndpoint -Object $payload -EndpointName "StorageService" -EndpointType "generic" -ProjectName "FileStorage"
```

This command constructs a generic service connection named "StorageService" for the project "FileStorage". The service connection links to the storage service at "https://storage.example.com" and uses the provided access key for authentication.

## PARAMETERS

### Object

Hashtable of Payload for REST call

```yaml
Type: Hashtable
Required: True
Accept pipeline input: true (ByPropertyName)
```

### EndpointName

The name displayed on the services page. In AzD this is the Connection Name.

```yaml
Type: String
Position: 2
```

### EndpointType

Type of endpoint (eg. `kubernetes`, `sonarqube`). See AzD service page for supported endpoints.

```yaml
Type: String
Position: 3
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### vsteam_lib.ServiceEndpoint

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Get-VSTeamServiceEndpoint](Get-VSTeamServiceEndpoint.md)

[Get-VSTeamServiceEndpointType](Get-VSTeamServiceEndpointType.md)

[Remove-VSTeamServiceEndpoint](Remove-VSTeamServiceEndpoint.md)
