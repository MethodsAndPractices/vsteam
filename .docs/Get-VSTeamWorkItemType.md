#include "./common/header.md"

# Get-VSTeamWorkItemType

## SYNOPSIS
#include "./synopsis/Get-VSTeamWorkItemType.md"

## SYNTAX

### List (Default)
```PowerShell
Get-VSTeamWorkItemType -ProjectName <String>
```

### ByType
```PowerShell
Get-VSTeamWorkItemType -ProjectName <String> -WorkItemType <String>
```

## Description
#include "./synopsis/Get-VSTeamWorkItemType.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```PowerShell
PS R:\repos\vsteam> Get-WorkItemType -ProjectName test -WorkItemType 'Code Review Response'
```

This command gets a single work item type.

## PARAMETERS

#include "./params/projectName.md"

### -WorkItemType
The type of work item to retrieve.

```yaml
Type: String
Parameter Sets: ByType
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
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

[Add-VSTeamAccount](Add-VSTeamAccount.md)