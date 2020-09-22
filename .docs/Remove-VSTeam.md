<!-- #include "./common/header.md" -->

# Remove-VSTeam

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeam.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeam.md" -->

## EXAMPLES

### Example 1: Remove second team

```powershell
Set-DefaultProject Test
Get-VSTeam | Select-Object -First 1 -Skip 1 | Remove-VSTeam
```

### Example 2: Remove team by name

```powershell
Remove-VSTeam LastTeam -ProjectName Test -Force
```

This command removes the team named 'LastTeam'.

### Example 2: Remove team by id

```powershell
Remove-VSTeam -Id 30246aee-95f8-45cc-9552-bceff1921a40 -Force
```

This command removes the team with id 30246aee-95f8-45cc-9552-bceff1921a40.

## PARAMETERS

### Id

The id of the team to remove.

```yaml
Type: String
Aliases: Name, TeamId, TeamName
Required: True
Position: 0
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
