<!-- #include "./common/header.md" -->

# Update-VSTeamWorkItemTag

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamWorkItemTag.md" -->

## SYNTAX

## DESCRIPTION

Updates a work item tag.

## EXAMPLES

### Example 1

```powershell
Update-VSTeamWorkItemTag -TagName
```

This will update a specific work item tag within the current project

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### TagIdOrName

Name or ID of the tag to return

```yaml
Type: String
Required: True
Position: named
```

### NewTagName

New name for the tag

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Get-VSTeamWorkItemTag](Get-VSTeamWorkItemTag.md)

[Remove-VSTeamWorkItemTag](Remove-VSTeamWorkItemTag.md)
