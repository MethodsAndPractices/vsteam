#include "./common/header.md"

# Add-VSTeamWorkItem

## SYNOPSIS

#include "./synopsis/Add-VSTeamWorkItem.md"

## SYNTAX

```powershell
Add-VSTeamWorkItem [-ProjectName] <String> -Tite <String> -WorkItemType <string>
```

## DESCRIPTION

Add-VSTeamWorkItem will add a new work item to your project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```powershell
PS C:\> Set-VSTeamDefaultProject Demo
PS C:\> Add-VSTeamWorkItem -Title "New Work Item" -WorkItemType Task

Build Definition Build Number  Status     Result
---------------- ------------  ------     ------
Demo-CI           Demo-CI-45   notStarted
```

## PARAMETERS

#include "./params/projectName.md"

### -WorkItemType
The type of work item to add.

You can tab complete from a list of available work item types.

You must use Set-VSTeamDefaultProject to set a default project to 
enable the tab completion.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

Project Name

### System.String

Work Item Type

## OUTPUTS

## NOTES

WorkItemType is a dynamic parameter and use the default
project value to query their validate set.

If you do not set the default project by called Set-VSTeamDefaultProject before
calling Add-VSTeamWorkItem you will have to type in the names.

## RELATED LINKS