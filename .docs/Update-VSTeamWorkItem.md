<!-- #include "./common/header.md" -->

# Update-VSTeamWorkItem

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamWorkItem.md" -->

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

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Set-VSTeamDefaultProject Demo
PS C:\> $additionalFields = @{"System.Tags"= "TestTag"; "System.AreaPath" = "Project\\MyPath"}
PS C:\> Update-VSTeamWorkItem -Title "Updated Work Item" -WorkItemType Task -Description "This is a description" -AdditionalFields $additionalFields

ID Title          Status
-- -----          ------
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

### -AdditionalFields

Hashtable which contains a key value pair of any field that should be filled with values. Key is the internal name of the field and the value is the content of the field being filled. E.g. the internal name for the area path is 'System.AreaPath'.

```yaml
Type: Hashtable
Required: False
```

<!-- #include "./params/force.md" -->

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

Any of the basic work item parameters defined in this method, will cause an exception if also added to the parameter AdditionalFields, since it is redundant. Either only use the parameter OR define them in the AdditionalFields parameter.

## RELATED LINKS
