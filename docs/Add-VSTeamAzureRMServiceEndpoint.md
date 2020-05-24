


# Add-VSTeamAzureRMServiceEndpoint

## SYNOPSIS

Adds a new Azure Resource Manager service endpoint.

## SYNTAX

## DESCRIPTION

The cmdlet adds a new connection between TFS/AzD and Azure using the Azure Resource Manager connection type.

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

### -SubscriptionName

The name of the Azure Subscription.

```yaml
Type: String
Aliases: displayName
Required: True
Position: 1
Accept pipeline input: true (ByPropertyName)
```

### -SubscriptionId

The id of the Azure subscription to use.

```yaml
Type: String
Required: True
Position: 2
Accept pipeline input: true (ByPropertyName)
```

### -SubscriptionTenantId

The id of the Azure tenant to use.

```yaml
Type: String
Required: True
Position: 3
Accept pipeline input: true (ByPropertyName)
```

### -ServicePrincipalId

The ID of the Azure Service Principal to use with this service endpoint.

```yaml
Type: String
Parameter Sets: Manual
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -ServicePrincipalKey

The key of the Azure Service Principal to use with this service endpoint.

```yaml
Type: String
Parameter Sets: Manual
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -EndpointName

The name displayed on the services page.
In AzD this is the Connection Name.

```yaml
Type: String
Position: 4
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-VSTeamServiceEndpoint](Get-VSTeamServiceEndpoint.md)

[Get-VSTeamServiceEndpointType](Get-VSTeamServiceEndpointType.md)

[Remove-VSTeamServiceEndpoint](Remove-VSTeamServiceEndpoint.md)

