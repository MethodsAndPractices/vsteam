<!-- #include "./common/header.md" -->

# Get-VSTeamWorkItemType

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamWorkItemType.md" -->

## SYNTAX

## Description

<!-- #include "./synopsis/Get-VSTeamWorkItemType.md" -->

## EXAMPLES

### Example 1

```PowerShell
PS R:\repos\vsteam> Get-VSTeamWorkItemType -ProjectName test -WorkItemType 'Code Review Response'
```

This command gets a single work item type.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -WorkItemType

The type of work item to retrieve.

```yaml
Type: String
Parameter Sets: ByType
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

The JSON returned has empty named items i.e.
"": "To Do"
This causes issues with the ConvertFrom-Json CmdLet.  Therefore, all "": are replaced with "_end":

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)
