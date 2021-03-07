<!-- #include "./common/header.md" -->

# Add-VSTeam

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeam.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeam.md" -->

## EXAMPLES

### Example 1: Add a team

```powershell
Add-VSTeam -ProjectName Scrum -Name 'Testing'
```

This command adds a team named 'Testing' to the project named 'Scrum'.

### Example 2: Add a team with description

```powershell
Add-VSTeam 'Scrum' 'Testing2' 'Test team'
```

This command adds a team named 'Testing2' with description 'Test team' to the project named 'Scrum'.

## PARAMETERS

### Name

The name of the team

```yaml
Type: String
Aliases: TeamName
Required: True
Position: 0
```

### Description

The description of the team.

```yaml
Type: String
Position: 1
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VSTeam](Get-VSTeam.md)

[Remove-VSTeam](Remove-VSTeam.md)

[Show-VSTeam](Show-VSTeam.md)

[Update-VSTeam](Update-VSTeam.md)