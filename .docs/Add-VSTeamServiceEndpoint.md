#include "./common/header.md"

# Add-VSTeamServiceEndpoint

## SYNOPSIS
#include "./synopsis/Add-VSTeamServiceEndpoint.md"

## SYNTAX

### Plain
```
Add-VSTeamServiceEndpoint [-ProjectName] <String> [-Object] <hashtable>
 [[-EndpointName] <String>]  [[-EndpointType] <String>]
```

## DESCRIPTION
The cmdlet adds a new generic connection between TFS/VSTS and a third party service (see VSTS for available connections) 

## EXAMPLES

## PARAMETERS

### -Object
Hashtable of Payload for REST call

```yaml
Type: Hashtable
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
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```


### -EndpointType
Type of endpoint (eg. `kubernetes`, `sonarqube`). See VSTS service page for supported endpoints.

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
#include "./params/projectName.md"

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

