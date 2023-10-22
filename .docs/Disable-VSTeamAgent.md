<!-- #include "./common/header.md" -->

# Disable-VSTeamAgent

## SYNOPSIS

<!-- #include "./synopsis/Disable-VSTeamAgent.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Disable-VSTeamAgent.md" -->

## EXAMPLES

### Example 1

```powershell
Disable-VSTeamAgent -PoolId 4 -Id 23
```

This command disables the agent with the ID 23 in the pool with the ID 4.

### Example 2

```powershell
Disable-VSTeamAgent -PoolId 2 -Id 10, 11, 12
```

This example disables multiple agents with the IDs 10, 11, and 12 in the pool with the ID 2.

### Example 3

```powershell
$agentIDs = @(33,34,35)
Disable-VSTeamAgent -PoolId 5 -Id $agentIDs
```

In this example, agents with IDs 33, 34, and 35 in the pool with the ID 5 are disabled using an array variable.

### Example 4

```powershell
Get-VSTeamAgent -PoolId 3 | Where-Object { $_.status -eq "Online" } | ForEach-Object { Disable-VSTeamAgent -PoolId 3 -Id $_.id }
```

This command retrieves all agents in the pool with the ID 3, filters to get only the online agents, and then disables each of those online agents.

### Example 5

```powershell
Disable-VSTeamAgent -PoolId 6 -Id 40 -Force
```

This example disables the agent with ID 40 in the pool with ID 6 without prompting for confirmation by using the `-Force` switch.

### Example 6

```powershell
Disable-VSTeamAgent -PoolId 7 -Id 45 -WhatIf
```

This command shows what would happen if the agent with ID 45 in the pool with ID 7 was disabled, without actually disabling the agent.

## PARAMETERS

### PoolId

Id of the pool.

```yaml
Type: int
Required: True
Accept pipeline input: true (ByValue)
```

### Id

Id of the agent to disable.

```yaml
Type: int[]
Aliases: AgentID
Required: True
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

### System.String

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
