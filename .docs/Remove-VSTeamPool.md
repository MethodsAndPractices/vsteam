<!-- #include "./common/header.md" -->

# Remove-VSTeamPool

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamPool.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamPool.md" -->

## EXAMPLES

### Example 1
```powershell
Remove-VSTeamPool -Id 101
```

Removes the pool with ID `101`.

### Example 2
```powershell
$poolsToRemove = 101, 102, 103
$poolsToRemove | ForEach-Object { Remove-VSTeamPool -Id $_ }
```

Removes multiple pools with IDs `101`, `102`, and `103`.

### Example 3
```powershell
$poolsToRemove = 101, 102, 103
$poolsToRemove | Remove-VSTeamPool -Id $_
```

Another method to remove multiple pools with IDs `101`, `102`, and `103` using pipeline input.

## PARAMETERS

### Id

Id of the pool to delete.

```yaml
Type: int
Parameter Sets: ByID
Aliases: PoolID
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamPool](Add-VSTeamPool.md)
[Update-VSTeamPool](Update-VSTeamPool.md)
[Get-VSTeamPool](Get-VSTeamPool.md)
