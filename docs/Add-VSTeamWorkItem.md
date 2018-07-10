


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

Build Definition Build Number  Status     Result
---------------- ------------  ------     ------
Demo-CI           Demo-CI-45   notStarted
```

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Required: true
Position: 0
Accept pipeline input: true (ByPropertyName)
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