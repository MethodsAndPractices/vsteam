<!-- #include "./common/header.md" -->

# Add-VSTeamPullRequest

## SYNOPSIS

Create a new Pull Request

## SYNTAX

## DESCRIPTION

Create a new Pull Request

## EXAMPLES

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -RepositoryId

Specifies the ID of the repository

```yaml
Type: Guid
Required: True
Aliases: Id
Accept pipeline input: true (ByPropertyName)
```

### -SourceRefName

A source reference, like a branch or commit
Needs to be in ref format like refs/heads/MyBranch

```yaml
Type: String
Required: True
```

### -TargetRefName

A target reference, like a branch or commit
Needs to be in ref format like refs/heads/MyBranch

```yaml
Type: String
Required: True
```

### -Title

The title of the pull request

```yaml
Type: String
Required: True
```

### -Description

The description of the pull request

```yaml
Type: String
Required: True
```

### -Draft

Mark the new pull request as a draft

```yaml
Type: Switch
```

<!-- #include "./params/confirm.md" -->

<!-- #include "./params/force.md" -->

<!-- #include "./params/whatIf.md" -->

## INPUTS

## OUTPUTS

### Team.PullRequest

## NOTES

## RELATED LINKS
