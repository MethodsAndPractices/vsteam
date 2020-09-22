<!-- #include "./common/header.md" -->

# Get-VSTeamWorkItemType

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamWorkItemType.md" -->

## SYNTAX

## Description

<!-- #include "./synopsis/Get-VSTeamWorkItemType.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamWorkItemType -ProjectName test -WorkItemType 'Code Review Response'
```

This command gets a single work item type.

## PARAMETERS

### WorkItemType

The type of work item to retrieve.

```yaml
Type: String
Parameter Sets: ByType
```

<!-- #include "./params/projectName.md" -->

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

The JSON returned has empty named items i.e.
"": "To Do"
This causes issues with the ConvertFrom-Json CmdLet.  Therefore, all "": are replaced with "_end":

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
