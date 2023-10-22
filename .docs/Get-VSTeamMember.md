<!-- #include "./common/header.md" -->

# Get-VSTeamMember

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamMember.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamMember.md" -->

## EXAMPLES

### Example 1
```powershell
Get-VSTeamMember -TeamId 'DevOpsTeam'
```

Returns all members of the team with the id "DevOpsTeam".

### Example 2
```powershell
Get-VSTeamMember -TeamId 'DevOpsTeam' -Top 10
```

Returns the top 10 members of the team with the id "DevOpsTeam".

### Example 3
```powershell
Get-VSTeamMember -TeamId 'DevOpsTeam' -Skip 5 -Top 10
```

Skips the first 5 members and then returns the next 10 members of the team with the id "DevOpsTeam".

### Example 4
```powershell
Get-VSTeamMember -TeamId 'DevOpsTeam' | Where-Object { $_.DisplayName -like "*Smith*" }
```

Returns members of the team with the id "DevOpsTeam" whose display name contains "Smith".

### Example 5
```powershell
Get-VSTeamMember -TeamId 'DevOpsTeam' -ProjectName 'ProjectX'
```

Returns members of the team with the id "DevOpsTeam" that are part of 'ProjectX'.

## PARAMETERS

### Skip

The number of items to skip.

```yaml
Type: Int32
```

### TeamId

The id of the team to search.

```yaml
Type: String
Aliases: name
Required: True
Position: 2
Accept pipeline input: true (ByPropertyName)
```

### Top

Specifies the maximum number to return.

```yaml
Type: Int32
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### vsteam_lib.TeamMember

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
