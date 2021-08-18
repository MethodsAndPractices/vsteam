<!-- #include "./common/header.md" -->

# Remove-VSTeamWiki

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamWiki.md" -->

## SYNTAX

## DESCRIPTION

Un-publish a code or project wiki in to the selected repo

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### Example 1

```powershell
Remove-VSTeamWiki -ProjectName myProject -WikiName myWikiName
```

This will Un-publish a wiki by name, project name required

### Example 2

```powershell
Remove-VSTeamWiki -WikiId 00000000-0000-0000-0000-000000000000
```

This will Un-publish a wiki by Id

## PARAMETERS

<!-- #include "./params/projectName.md" -->`

### WikiName

Name of the Wiki to Un-publish

```yaml
Type: String
Required: True
Position: named
Alias: Name
Parameter Sets: ByName
```

### WikiId

Id of the Wiki to Un-publish

```yaml
Type: String
Required: True
Position: named
Alias: Id
Parameter Sets: ById
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VSTeamWiki](Get-VSTeamWiki.md)

[Add-VSTeamWiki](Add-VSTeamWiki.md)
