#include "./common/header.md"

# Update-VSTeamServiceEndpoint

## SYNOPSIS
#include "./synopsis/Add-VSTeamServiceEndpoint.md"

## SYNTAX

### Plain
```
Update-VSTeamServiceEndpoint [-ProjectName] <String> [-Object] <hashtable>
 [[-Id] <String>]
```

## DESCRIPTION
The cmdlet updates an existing connection between TFS/VSTS and a third party service (see VSTS for available connections) 

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


### -Id
UUID of existing services endpoint from VSTS

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
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

