<!-- #include "./common/header.md" -->

# Add-VSTeamWiki

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamWiki.md" -->

## SYNTAX

## DESCRIPTION

Publish a code or project wiki in to the selected repo

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### Example 1

```powershell
Add-VSTeamWiki -ProjectName myProject -Name myProjectWiki
```

This will create a project wiki

### Example 2

```powershell
Add-VSTeamWiki -ProjectName myProject -Name myCodeWiki -repositoryId 00000000-0000-0000-0000-000000000000 -branch main -mappedPath '/.Docs'
```

This will create a code wiki from main branch and publish '.Docs' folder

## PARAMETERS

<!-- #include "./params/projectName.md" -->`

### Name

Name or ID of the Wiki to return

```yaml
Type: String
Required: True
Position: named
```

### RepositoryId

ID of the repository to publish from

```yaml
Type: String
Required: True
Position: named
Parameter Sets: codeWiki
```

### Branch

Name of the branch in the repo to publish from

```yaml
Type: String
Required: False
Position: named
Parameter Sets: codeWiki
```

### mappedPath

Path inside the repo to publish

```yaml
Type: String
Required: True
Position: named
Parameter Sets: codeWiki
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VSTeamWiki](Get-VSTeamWiki.md)

[Remove-VSTeamWiki](Remove-VSTeamWiki.md)
