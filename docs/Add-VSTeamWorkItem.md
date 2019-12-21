


# Add-VSTeamWorkItem

## SYNOPSIS

Adds a work item to your project.

## SYNTAX

## DESCRIPTION

Add-VSTeamWorkItem will add a new work item to your project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Set-VSTeamDefaultProject Demo
PS C:\> Add-VSTeamWorkItem -Title "New Work Item" -WorkItemType Task

ID Title          Status
-- -----          ------
6  New Work Item  To Do
```

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Set-VSTeamDefaultProject Demo
PS C:\> Add-VSTeamWorkItem -Title "New Work Item" -WorkItemType Task -Description "This is a description"

ID Title          Status
-- -----          ------
6  New Work Item  To Do
```

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Set-VSTeamDefaultProject Demo
PS C:\> $additionalFields = @{"System.Tags"= "TestTag"; "System.AreaPath" = "Project\\MyPath"}
PS C:\> Add-VSTeamWorkItem -Title "New Work Item" -WorkItemType Task -Description "This is a description" -AdditionalFields $additionalFields

ID Title          Status
-- -----          ------
6  New Work Item  To Do
```

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

### -Title

The title of the work item

```yaml
Type: String
Required: True
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

### -WorkItemType

The type of work item to add.

You can tab complete from a list of available work item types.

You must use Set-VSTeamDefaultProject to set a default project to enable the tab completion.

```yaml
Type: String
Required: True
```

### -ParentId

The Id of the parent work item that this work item will be related to.

```yaml
Type: Int
Required: False
```

### -AdditionalFields

Hashtable which contains a key value pair of any field that should be filled with values. Key is the internal name of the field and the value is the content of the field being filled. E.g. the internal name for the area path is 'System.AreaPath'.

```yaml
Type: Hashtable
Required: False
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
calling Add-VSTeamWorkItem you will have to type in the names.

Any of the basic work item parameters defined in this method, will cause an exception if also added to the parameter AdditionalFields, since it is redundant. Either only use the parameter OR define them in the AdditionalFields parameter.

## RELATED LINKS

