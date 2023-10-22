<!-- #include "./common/header.md" -->

# Enable-VSTeamAgent

## SYNOPSIS

<!-- #include "./synopsis/Enable-VSTeamAgent.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Enable-VSTeamAgent.md" -->

## EXAMPLES

### Example 1

```powershell
Enable-VSTeamAgent -PoolId 4 -Id 23
```

This command enables the agent with the ID 23 in the pool with the ID 4.

### Example 2

```powershell
Enable-VSTeamAgent -PoolId 2 -Id 10, 11, 12
```

This example enables multiple agents with the IDs 10, 11, and 12 in the pool with the ID 2.

### Example 3

```powershell
$agentIDs = @(33,34,35)
Enable-VSTeamAgent -PoolId 5 -Id $agentIDs
```

In this example, agents with IDs 33, 34, and 35 in the pool with the ID 5 are enabled using an array variable.

### Example 4

```powershell
Get-VSTeamAgent -PoolId 3 | Where-Object { $_.status -eq "Offline" } | ForEach-Object { Enable-VSTeamAgent -PoolId 3 -Id $_.id }
```

This command retrieves all agents in the pool with the ID 3, filters to get only the offline agents, and then enables each of those offline agents.

## PARAMETERS

### PoolId

Id of the pool.

```yaml
Type: int
Required: True
Accept pipeline input: true (ByValue)
```

### Id

Id of the agent to enable.

```yaml
Type: int[]
Aliases: AgentID
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

### System.String

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
