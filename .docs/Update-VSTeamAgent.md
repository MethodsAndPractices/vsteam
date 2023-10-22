<!-- #include "./common/header.md" -->

# Update-VSTeamAgent

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamAgent.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamAgent.md" -->

## EXAMPLES

### Example 1
```powershell
Update-VSTeamAgent -PoolId 101 -Id 2021
```

Updates the agent with ID `2021` in the pool with ID `101`.

### Example 2
```powershell
$agentIds = 2021, 2022, 2023
Update-VSTeamAgent -PoolId 101 -Id $agentIds
```

Updates multiple agents with IDs `2021`, `2022`, and `2023` in the pool with ID `101`.

### Example 3
```powershell
Update-VSTeamAgent -PoolId 101 -Id 2021 -Force
```

Updates the agent with ID `2021` in the pool with ID `101` and forces the update without any confirmation prompts.

## PARAMETERS

### PoolId

Id of the pool.

```yaml
Type: int
Required: True
Accept pipeline input: true (ByValue)
```

### Id

Id of the agent to Update.

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
