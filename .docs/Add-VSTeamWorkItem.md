<!-- #include "./common/header.md" -->

# Add-VSTeamWorkItem

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamWorkItem.md" -->

## SYNTAX

## DESCRIPTION

Add-VSTeamWorkItem will add a new work item to your project.

## EXAMPLES

### Example 1

```powershell
Set-VSTeamDefaultProject Demo
Add-VSTeamWorkItem -Title "New Work Item" -WorkItemType Task

ID Title          Status
-- -----          ------
6  New Work Item  To Do
```

### Example 2

```powershell
Set-VSTeamDefaultProject Demo
Add-VSTeamWorkItem -Title "New Work Item" -WorkItemType Task -Description "This is a description"

ID Title          Status
-- -----          ------
6  New Work Item  To Do
```

### Example 3

```powershell
Set-VSTeamDefaultProject Demo
$additionalFields = @{"System.Tags"= "TestTag"; "System.AreaPath" = "Project\\MyPath"}
Add-VSTeamWorkItem -Title "New Work Item" -WorkItemType Task -Description "This is a description" -AdditionalFields $additionalFields

ID Title          Status
-- -----          ------
6  New Work Item  To Do
```

## PARAMETERS

### Title

The title of the work item

```yaml
Type: String
Required: True
```

### Description

The Description of the work item

```yaml
Type: String
Required: False
```

### IterationPath

The IterationPath of the work item

```yaml
Type: String
Required: False
```

### AssignedTo

The email address of the user this work item will be assigned to.

```yaml
Type: String
Required: False
```

### WorkItemType

The type of work item to add.

You can tab complete from a list of available work item types.

You must use Set-VSTeamDefaultProject to set a default project to enable the tab completion.

```yaml
Type: String
Required: True
```

### ParentId

The Id of the parent work item that this work item will be related to.

```yaml
Type: Int
Required: False
```

### AdditionalFields

Hashtable which contains a key value pair of any field that should be filled with values. Key is the internal name of the field and the value is the content of the field being filled. E.g. the internal name for the area path is 'System.AreaPath'.

```yaml
Type: Hashtable
Required: False
```

<!-- #include "./params/projectName.md" -->

## INPUTS

### System.String

ProjectName

WorkItemType

## OUTPUTS

## NOTES

WorkItemType is a dynamic parameter and uses the project value to query their validate set.

If you do not set the default project by calling Set-VSTeamDefaultProject before calling Add-VSTeamWorkItem you need to provide the -ProjectName before -WorkItemType or will have to type in the names.

Any of the basic work item parameters defined in this method, will cause an exception if also added to the parameter AdditionalFields, since it is redundant. Either only use the parameter or define them in the AdditionalFields parameter.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
