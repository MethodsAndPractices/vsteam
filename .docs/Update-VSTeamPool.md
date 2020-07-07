<!-- #include "./common/header.md" -->

# Update-VSTeamPool

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamPool.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamPool.md" -->

## EXAMPLES

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

Name of the pool to create.

```yaml
Type: string
Required: True
```

### -Description

Description of the pool to create.

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

[Remove-VSTeamAccount](Remove-VSTeamAccount.md)
[ADd-VSTeamAccount](Add-VSTeamAccount.md)
[Get-VSTeamAccount](Get-VSTeamAccount.md)
