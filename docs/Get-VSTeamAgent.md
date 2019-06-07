


# Get-VSTeamAgent

## SYNOPSIS

Returns the agents in a pool.

## SYNTAX

## DESCRIPTION

Returns the agents in a pool.

## EXAMPLES

## PARAMETERS

### -PoolId

Id of the pool.

```yaml
Type: String
Required: True
Accept pipeline input: true (ByValue)
```

### -Id

Id of the agent to return.

```yaml
Type: String
Parameter Sets: ByID
Aliases: AgentID
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

To read system capabilities that contain dots you have to use the PSObject Properties property.

(Get-VSTeamAgent 1 91).systemCapabilities.PSObject.Properties['Agent.OS'].Value

## RELATED LINKS

