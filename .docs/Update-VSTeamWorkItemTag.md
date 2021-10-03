<!-- #include "./common/header.md" -->

# Update-VSTeamWorkItemTag

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamWorkItemTag.md" -->

## SYNTAX

## DESCRIPTION

Updates a work item tag.

You must call `Set-VSTeamAccount` before calling this function.

## EXAMPLES

### Example 1

```powershell
Update-VSTeamWorkItemTag -TagName
```

This will update a specific work item tag within the current project

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### NameOrTagId

Name or ID of the tag to return

```yaml
Type: String
Required: True
Position: named
Aliases: TagName, TagId
Parameter Sets: ByIdentifier
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VSTeamWorkItemTag](Get-VSTeamWorkItemTag.md)

[Remove-VSTeamWorkItemTag](Remove-VSTeamWorkItemTag.md)
