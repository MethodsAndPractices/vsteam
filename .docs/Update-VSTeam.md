<!-- #include "./common/header.md" -->

# Update-VSTeam

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeam.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeam.md" -->

## EXAMPLES

### Example 1
```powershell
Update-VSTeam -Name "OldTeamName" -NewTeamName "NewTeamName"
```

Updates the team name from "OldTeamName" to "NewTeamName".

### Example 2
```powershell
Update-VSTeam -Name "TeamName" -Description "Updated Team Description"
```

Updates the description of the team named "TeamName" to "Updated Team Description".

### Example 3
```powershell
Update-VSTeam -Name "TeamName" -NewTeamName "NewTeamName" -ProjectName "MyProject"
```

Updates the team name within the "MyProject" project from "TeamName" to "NewTeamName".

### Example 4
```powershell
Update-VSTeam -Name "TeamName" -NewTeamName "NewTeamName" -Force
```

Updates the team name from "TeamName" to "NewTeamName" and forces the update without any confirmation prompts.

## PARAMETERS

### Name

The name of the team to update

```yaml
Type: String
Position: 0
Aliases: Id, TeamToUpdate, TeamId, TeamName
Required: True
Accept pipeline input: true (ByPropertyName)
```

### NewTeamName

The new name of the team

```yaml
Type: String
```

### Description

The new description of the team

```yaml
Type: String
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

### System.String

Description

Name

NewTeamName

## OUTPUTS

### vsteam_lib.Team

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
