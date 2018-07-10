<!-- #include "./common/header.md" -->

# Add-VSTeamServiceEndpoint

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamServiceEndpoint.md" -->

## SYNTAX

## DESCRIPTION

The cmdlet adds a new generic connection between TFS/VSTS and a third party service (see VSTS for available connections).

## EXAMPLES

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Object

Hashtable of Payload for REST call

```yaml
Type: Hashtable
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -EndpointName

The name displayed on the services page. In VSTS this is the Connection Name.

```yaml
Type: String
Position: 2
```

### -EndpointType

Type of endpoint (eg. `kubernetes`, `sonarqube`). See VSTS service page for supported endpoints.

```yaml
Type: String
Position: 3
```

## INPUTS

## OUTPUTS

### Team.ServiceEndpoint

## NOTES

## RELATED LINKS