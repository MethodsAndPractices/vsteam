<!-- #include "./common/header.md" -->

# Update-VSTeamPool

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamPool.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamPool.md" -->

## EXAMPLES

### Example 1

```powershell
Update-VSTeamPool -Id 13 -Name "UpdatedTestPoolName" -Description "Test Description" -AutoProvision -NoAutoUpdates
```
Updates the pool with id 13 with the name new "UpdatedTestPoolName" that is auto-provisioning to every project and agent software is not updating automatically.

## PARAMETERS

### -Id

Id of the pool to return.

```yaml
Type: int
Parameter Sets: ByID
Aliases: PoolID
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -Name

Name of the pool to update.

```yaml
Type: string
Required: True
```

### -Description

Description of the pool to update.

```yaml
Type: string
Required: False
```

### -AutoProvision

Auto-provision this agent pool in new projects.

```yaml
Type: string
Required: True
```

### -NoAutoUpdates

Turn off automatic updates of agents in the pool. Default is turned on.

```yaml
Type: string
Required: True
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Remove-VSTeamPool](Remove-VSTeamPool.md)
[Add-VSTeamPool](Add-VSTeamPool.md)
[Get-VSTeamPool](Get-VSTeamPool.md)

<!-- #include "./common/related.md" -->
