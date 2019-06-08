


# Get-VSTeamWorkItemType

## SYNOPSIS

Gets a list of all Work Item Types or a single work item type.

## SYNTAX

## Description

Gets a list of all Work Item Types or a single work item type.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS R:\repos\vsteam> Get-WorkItemType -ProjectName test -WorkItemType 'Code Review Response'
```

This command gets a single work item type.

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 0
Required: True
Accept pipeline input: true (ByPropertyName)
```

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

