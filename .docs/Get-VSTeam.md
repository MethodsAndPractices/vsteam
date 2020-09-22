<!-- #include "./common/header.md" -->

# Get-VSTeam

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeam.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeam.md" -->

## EXAMPLES

### Example 1: Get team by name

```powershell
Get-VSTeamProject | Get-VSTeam 'Test Team'
```

This command pipes the project name to Get-VSTeam and returns the team with the name 'Test Team'

## PARAMETERS

### Skip

The number of items to skip.

```yaml
Type: Int32
Parameter Sets: List
```

### Top

Specifies the maximum number to return.

```yaml
Type: Int32
Parameter Sets: List
```

### Name

The name of the team to retrieve.

```yaml
Type: String[]
Parameter Sets: ByName
Position: 0
```

### TeamId

The id of the team to retrieve.

```yaml
Type: String[]
Parameter Sets: ByID
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### vsteam_lib.Team

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
