<!-- #include "./common/header.md" -->

# Get-VSTeamWorkItemTag

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamWorkItemTag.md" -->

## SYNTAX

## DESCRIPTION

Returns a list of work item tags in a project.

A single tag can be returned by providing the tag name or id.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamWorkItemTag
```

This will return a list of all the work item tags within the current project

### Example 2

```powershell
Get-VSTeamWorkItemTag -TagId my-tag
```

This will return a specific work item tag

### Example 3

```powershell
Get-VSTeamWorkItemTag -TagName my-tag
```

This will return a specific work item tag

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



[Update-VSTeamWorkItemTag](Update-VSTeamWorkItemTag.md)

[Remove-VSTeamWorkItemTag](Remove-VSTeamWorkItemTag.md)
