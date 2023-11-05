<!-- #include "./common/header.md" -->

# Get-VSTeamAgent

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamAgent.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamAgent.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamAgent -PoolId 5
```

This command retrieves all agents within the pool with the ID 5.

### Example 2

```powershell
Get-VSTeamAgent -PoolId 3 -Id 42
```

This example fetches the agent with the ID 42 within the pool with the ID 3.

### Example 3

```powershell
$agent = Get-VSTeamAgent -PoolId 1 -Id 91
$agent.systemCapabilities.PSObject.Properties['Agent.OS'].Value
```

In this example, the agent with the ID 91 in the pool with the ID 1 is fetched. Afterwards, the system capability 'Agent.OS' of the agent is displayed.

### Example 4

```powershell
$agents = Get-VSTeamAgent -PoolId 2
$agents | Where-Object { $_.status -eq "Online" }
```

This command retrieves all agents in the pool with the ID 2 and then filters to show only those agents that are currently online.

## PARAMETERS

### PoolId

Id of the pool.

```yaml
Type: String
Required: True
Accept pipeline input: true (ByValue)
```

### Id

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

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
