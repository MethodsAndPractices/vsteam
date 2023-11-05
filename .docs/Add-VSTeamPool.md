<!-- #include "./common/header.md" -->

# Add-VSTeamPool

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamPool.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamPool.md" -->

## EXAMPLES

### Example 1

```powershell
Add-VSTeamPool -Name "TestPool" -Description "Test Description" -AutoProvision -AutoAuthorize -NoAutoUpdates
```

It's creating an agent pool with the name "TestPool" that is auto provisioning to every project and also pre-authorized to be used with every pipeline. Agent software is not updated automatically.

## PARAMETERS

### Name

Name of the pool to create.

```yaml
Type: string
Required: True
```

### Description

Description of the pool to create.

```yaml
Type: string
Required: False
```

### AutoProvision

Auto-provision this agent pool in new projects.

```yaml
Type: string
Required: True
```

### AutoAuthorize

Grant access permission to all pipelines.

```yaml
Type: string
Required: True
```

### NoAutoUpdates

Turn off automatic updates of agents in the pool. Default is turned on.

```yaml
Type: string
Required: True
```

## INPUTS

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Remove-VSTeamPool](Remove-VSTeamPool.md)
[Update-VSTeamPool](Update-VSTeamPool.md)
[Get-VSTeamPool](Get-VSTeamPool.md)
