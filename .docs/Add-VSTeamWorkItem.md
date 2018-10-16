<!-- #include "./common/header.md" -->

# Add-VSTeamWorkItem

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamWorkItem.md" -->

## SYNTAX

## DESCRIPTION

Add-VSTeamWorkItem will add a new work item to your project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Set-VSTeamDefaultProject Demo
PS C:\> Add-VSTeamWorkItem -Title "New Work Item" -WorkItemType Task

Build Definition Build Number  Status     Result
---------------- ------------  ------     ------
Demo-CI           Demo-CI-45   notStarted
```

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Set-VSTeamDefaultProject Demo
PS C:\> Add-VSTeamWorkItem -Title "New Work Item" -WorkItemType Task -Description "This is a description"

Build Definition Build Number  Status     Result
---------------- ------------  ------     ------
Demo-CI           Demo-CI-45   notStarted
```

## PARAMETERS

<!-- #include "./params/projectName.md" -->

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

## RELATED LINKS