#include "./common/header.md"

# Get-VSTeamWorkItem

## SYNOPSIS

#include "./synopsis/Get-VSTeamWorkItem.md"

## SYNTAX

```powershell
Get-VSTeamWorkItem [-ProjectName] <String> -Id <Int32[]>
```

## DESCRIPTION

#include "./synopsis/Get-VSTeamWorkItem.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```powershell
PS C:\> Get-VSTeamWorkItem -ProjectName demo -Id 47,48
```

This command gets work items with IDs 47 and 48 by using the ID parameter.


## PARAMETERS

#include "./params/projectName.md"

### -Id
The id of the work item.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: BuildID

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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
calling Get-VSTeamWorkItem you will have to type in the names.

## RELATED LINKS