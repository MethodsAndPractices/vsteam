


# Get-VSTeamJobRequest

## SYNOPSIS

Returns all the job requests of an agent.

## SYNTAX

## DESCRIPTION

Returns all the job requests of an agent.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamJobRequest 1 111
```

This will display all the job request of agent with id 111 under the pool with id 1.

## PARAMETERS

### -PoolId

Id of the pool.

```yaml
Type: String
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -AgentId

Id of the agent to return.

```yaml
Type: String
Required: True
Accept pipeline input: true (ByValue)
```

### -CompletedRequestCount

The number of requests to return.

```yaml
Type: Int32
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

