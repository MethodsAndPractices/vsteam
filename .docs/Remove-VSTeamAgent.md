<!-- #include "./common/header.md" -->

# Remove-VSTeamAgent

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamAgent.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamAgent.md" -->

## EXAMPLES

### Example 1
```powershell
Remove-VSTeamAgent -PoolId 101 -Id 2021
```

Removes the agent with ID `2021` from the pool with ID `101`.

### Example 2
```powershell
$agentIds = 2021, 2022, 2023
Remove-VSTeamAgent -PoolId 101 -Id $agentIds
```

Removes multiple agents with IDs `2021`, `2022`, and `2023` from the pool with ID `101`.

### Example 3
```powershell
Remove-VSTeamAgent -PoolId 101 -Id 2021 -Force
```

Removes the agent with ID `2021` from the pool with ID `101` and forces the removal without any confirmation prompts.

## PARAMETERS

### PoolId

Id of the pool.

```yaml
Type: int
Required: True
Accept pipeline input: true (ByValue)
```

### Id

Id of the agent to remove.

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
