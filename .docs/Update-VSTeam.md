<!-- #include "./common/header.md" -->

# Update-VSTeam

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeam.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeam.md" -->

## EXAMPLES

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

<!-- #include "./common/related.md" -->
