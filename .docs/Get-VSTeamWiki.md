<!-- #include "./common/header.md" -->

# Get-VSTeamWiki

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamWiki.md" -->

## SYNTAX

## DESCRIPTION

Returns a list of wikis in a project

A single wiki can be returned by providing the wiki namd or Id

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamWiki
```

This will return a list of all the wikis for all the projects

### Example 2

```powershell
Get-VSTeamWiki -ProjectName myProject
```

This will return all the wikis for the specified project

### Example 3

```powershell
Get-VSTeamWiki -ProjectName myProject -WikiName my-code-wiki
```

This will return the specified wiki in the project provided

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### Name

Name or ID of the Wiki to return

```yaml
Type: String
Required: True
Position: named
Aliases: WikiName, WikiId
Parameter Sets: ByIdentifier
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamWiki](Add-VSTeamWiki.md)

[Remove-VSTeamWiki](Remove-VSTeamWiki.md)
