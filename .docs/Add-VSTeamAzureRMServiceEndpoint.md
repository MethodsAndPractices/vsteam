<!-- #include "./common/header.md" -->

# Add-VSTeamAzureRMServiceEndpoint

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamAzureRMServiceEndpoint.md" -->

## SYNTAX

## DESCRIPTION

The cmdlet adds a new connection between TFS/AzD and Azure using the Azure Resource Manager connection type.

## EXAMPLES

### Example 1

```powershell
Add-VSTeamAzureRMServiceEndpoint -SubscriptionName "MyAzureSubscription" -SubscriptionId "1234abcd-5678-efgh-9012-ijklmn345678" -SubscriptionTenantId "abcd1234-efgh-5678-ijkl-9012mn345678" -ServicePrincipalId "efgh1234-5678-abcd-9012-ijklmn345678" -ServicePrincipalKey "my-service-principal-key" -EndpointName "MyAzureEndpoint" -ProjectName "MyProject"
```

This command adds a new Azure Resource Manager service endpoint in the project named "MyProject" using the provided Azure subscription name, subscription ID, tenant ID, service principal ID, and service principal key. The service endpoint will be named "MyAzureEndpoint".

### Example 2

```powershell
$params = @{
    SubscriptionName = "MyAzureSubscription";
    SubscriptionId = "1234abcd-5678-efgh-9012-ijklmn345678";
    SubscriptionTenantId = "abcd1234-efgh-5678-ijkl-9012mn345678";
    ServicePrincipalId = "efgh1234-5678-abcd-9012-ijklmn345678";
    ServicePrincipalKey = "my-service-principal-key";
    EndpointName = "MyAzureEndpoint";
    ProjectName = "MyProject";
}
Add-VSTeamAzureRMServiceEndpoint @params
```

This example does the same as the previous one but uses a hashtable to define the parameters for the `Add-VSTeamAzureRMServiceEndpoint` cmdlet.

### Example 3

```powershell
$endpoint = @{
    SubscriptionName = "MyAzureSubscription";
    SubscriptionId = "1234abcd-5678-efgh-9012-ijklmn345678";
    SubscriptionTenantId = "abcd1234-efgh-5678-ijkl-9012mn345678";
    ServicePrincipalId = "efgh1234-5678-abcd-9012-ijklmn345678";
    ServicePrincipalKey = "my-service-principal-key";
}
Add-VSTeamAzureRMServiceEndpoint @endpoint -EndpointName "MyAzureEndpoint" -ProjectName "MyProject"
```

This example demonstrates how you can separate the Azure-related parameters and the Azure DevOps-related parameters. The Azure parameters are stored in the `$endpoint` hashtable, and the Azure DevOps parameters are provided directly to the cmdlet.

Remember that when working with Azure, Service Principals are a way to give applications permissions in Azure Active Directory. This allows those applications to manage resources in Azure. The Service Principal ID and Key are used to authenticate and authorize the application. Always handle the Service Principal Key with care as it is a sensitive piece of information.

## PARAMETERS

### SubscriptionName

The name of the Azure Subscription.

```yaml
Type: String
Aliases: displayName
Required: True
Position: 1
Accept pipeline input: true (ByPropertyName)
```

### SubscriptionId

The id of the Azure subscription to use.

```yaml
Type: String
Required: True
Position: 2
Accept pipeline input: true (ByPropertyName)
```

### SubscriptionTenantId

The id of the Azure tenant to use.

```yaml
Type: String
Required: True
Position: 3
Accept pipeline input: true (ByPropertyName)
```

### ServicePrincipalId

The ID of the Azure Service Principal to use with this service endpoint.

```yaml
Type: String
Parameter Sets: Manual
Required: True
Accept pipeline input: true (ByPropertyName)
```

### ServicePrincipalKey

The key of the Azure Service Principal to use with this service endpoint.

```yaml
Type: String
Parameter Sets: Manual
Required: True
Accept pipeline input: true (ByPropertyName)
```

### EndpointName

The name displayed on the services page.
In AzD this is the Connection Name.

```yaml
Type: String
Position: 4
```

### Description

Description of the service endpoint.

```yaml
Type: String
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Get-VSTeamServiceEndpoint](Get-VSTeamServiceEndpoint.md)

[Get-VSTeamServiceEndpointType](Get-VSTeamServiceEndpointType.md)

[Remove-VSTeamServiceEndpoint](Remove-VSTeamServiceEndpoint.md)
