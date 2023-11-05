<!-- #include "./common/header.md" -->

# Get-VSTeamPool

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamPool.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamPool.md" -->

## EXAMPLES

### Example 1
```powershell
Get-VSTeamPool
```

Returns a list of all agent pools.

### Example 2
```powershell
Get-VSTeamPool -Id 12345
```

Returns the agent pool with the specified `Id` "12345".

### Example 3
```powershell
Get-VSTeamPool | Where-Object { $_.Name -eq "Default" }
```

Returns the agent pool with the name "Default".

### Example 4
```powershell
Get-VSTeamPool | Sort-Object Name
```

Returns all agent pools sorted by their name in ascending order.

## PARAMETERS

### Id

Id of the pool to return.

```yaml
Type: int
Parameter Sets: ByID
Aliases: PoolID
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

[Remove-VSTeamAccount](Remove-VSTeamAccount.md)
[Update-VSTeamAccount](Update-VSTeamAccount.md)
[Add-VSTeamAccount](Add-VSTeamAccount.md)
