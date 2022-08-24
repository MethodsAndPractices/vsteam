<!-- #include "./common/header.md" -->

# Update-VSTeamGitRepositoryDefaultBranch

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamGitRepositoryDefaultBranch.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamGitRepositoryDefaultBranch.md" -->

## EXAMPLES

### Example 1

```powershell
Update-VSTeamGitRepositoryDefaultBranch -ProjectName MyProject -Name MyRepo -DefaultBranch develop
```

This command sets the default branch for the 'MyRepo' git repository in the 'MyProject' project to 'develop'.

## PARAMETERS

### ProjectName

The name of the project which the target repository is a part of.

```yaml
Type: String
Required: True
Accept pipeline input: true #(ByPropertyName)
```

### Name

The name of the target repository.

```yaml
Type: String
Required: True
Accept pipeline input: true #(ByPropertyName)
```

### DefaultBranch

The new branch name to apply to the target repository.

```yaml
Type: String
Required: True
Accept pipeline input: true #(ByPropertyName)
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
