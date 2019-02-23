


# Update-VSTeamWorkItem

## SYNOPSIS

Update a work item in your project.

## SYNTAX

## DESCRIPTION

Update-VSTeamWorkItem will update a new work item in your project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Set-VSTeamDefaultProject Demo
PS C:\> Update-VSTeamWorkItem -WorkItemId 1 -Title "Updated Work Item"

ID Title              Status
-- -----              ------
6  Updated Work Item  To Do
```

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Set-VSTeamDefaultProject Demo
PS C:\> Update-VSTeamWorkItem -Title "Updated Work Item" -WorkItemType Task -Description "This is a description"

ID Title              Status
-- -----              ------
6  Updated Work Item  To Do
```

## PARAMETERS

### -Id

The id of the work item.

```yaml
Type: Int32
Parameter Sets: ByID
Required: True
Accept pipeline input: true (ByPropertyName, ByValue)
```

### -Title

The title of the work item

```yaml
Type: String
Required: False
```

### -Description

The Description of the work item

```yaml
Type: String
Required: False
```

### -IterationPath

The IterationPath of the work item

```yaml
Type: String
Required: False
```

### -AssignedTo

The email address of the user this work item will be assigned to.

```yaml
Type: String
Required: False
```

### -Tag

The tag(s) you want to add to the work item. This will overwrite any existing tags. Multiple tags can be entered using the semi-colon delimiter.

```yaml
Type: String
Required: False
```

### -Link

The link information to create relationships between work items. The link type is an object with the following Properties:
[string] rel - relationship type
[string] url - url to the work item to be linked
[string] comment - comment on why the link is being made

```yaml
Type: Object
Required: False
```

### -Force

Forces the command without confirmation

```yaml
Type: SwitchParameter
```

## INPUTS

### System.String

ProjectName

WorkItemType

## OUTPUTS

## NOTES

WorkItemType is a dynamic parameter and use the default
project value to query their validate set.

If you do not set the default project by called Set-VSTeamDefaultProject before
calling Update-VSTeamWorkItem you will have to type in the names.

## RELATED LINKS

