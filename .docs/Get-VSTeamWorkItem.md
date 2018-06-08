#include "./common/header.md"

# Get-VSTeamWorkItem

## SYNOPSIS

#include "./synopsis/Get-VSTeamWorkItem.md"

## SYNTAX

## DESCRIPTION

#include "./synopsis/Get-VSTeamWorkItem.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```powershell
PS C:\> Get-VSTeamWorkItem -ProjectName demo -Ids 47,48
```

This command gets work items with IDs 47 and 48 by using the ID parameter.


## PARAMETERS

#include "./params/projectName.md"

### -Id
The id of the work item.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Ids
The id of the work item.

```yaml
Type: Int32[]
Parameter Sets: List
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ErrorPolicy
The flag to control error policy in a bulk get work items request.

Valid values: Fail, Omit

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: True
Position: 1
Default value: Fail
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fields
Comma-separated list of requested fields.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Expand
Comma-separated list of requested fields.

Valid values: None, Relations, Fields, Links, All

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsOf

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: 

Required: False
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
calling Get-VSTeamWorkItem you will have to type in the names.

## RELATED LINKS