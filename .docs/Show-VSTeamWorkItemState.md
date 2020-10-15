<!-- #include "./common/header.md" -->

# Show-VSTeamWorkItemState

## SYNOPSIS

<!-- #include "./synopsis/Show-VSTeamWorkItemState.md" -->

## SYNTAX

## Description

Each WorkItem type in each process template has a set of possible states.  Items may have system-defined states and/or custom (user-defined) states. This command is used to un-hide system states which have previously been hidden

## EXAMPLES

### Example 1

```PowerShell
Show-VSTeamWorkItemState -WorkItemType Bug -Name Approved -ProcessTemplate Scrum2 -Force
```

This un-hides the "Approved" state for bug in the custom process template "Scrum2", without the confirmation prompt.
If the state is not hidden a warning message will appear and the state will not be changed.

## PARAMETERS

### -Name

The name of the state to be revealed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProcessTemplate

Specifies the process template where the WorkItem Type to be modified is found; by default this will be the template for the current project. Note that although some WorkItem types like "bug" or "task" are found in multiple templates, a change to the available states only applies to one template, and the built-in process templates cannot be modified. Values for this parameter should tab-complete.

```yaml
Type: String
Parameter Sets: Process
```

### -WorkItemType

The name of the WorkItem type whose state list is to be modified. Values for this parameter should tab-complete with types in the current project's process-template; types found only in other templates may need to be entered manually.

```yaml
Type: String
Parameter Sets: ByType
```
<!-- #include "./params/confirm.md" -->

<!-- #include "./params/Force.md" -->

<!-- #include "./params/whatif.md" -->

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Add-VSTeamWorkItemState](Add-VSTeamWorkItemState.md)

[Get-VSTeamWorkItemState](Get-VSTeamWorkItemState.md)

[Hide-VSTeamWorkItemState](Hide-VSTeamWorkItemState.md)

[Remove-VSTeamWorkItemState](Remove-VSTeamWorkItemState.md)