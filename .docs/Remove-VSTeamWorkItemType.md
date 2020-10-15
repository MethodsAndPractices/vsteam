<!-- #include "./common/header.md" -->

# Remove-VSTeamWorkItemType

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamWorkItemType.md" -->

## SYNTAX

## Description

Removes a custom work item type, or reverts an inherited work item type back to the built-in Type.

If the type is a system type (as all work item types in built-in Process templates are) then an error will be thrown.

## EXAMPLES

### Example 1

```powershell
Remove-VSTeamWorkItemType -ProcessTemplate Scrum5 -WorkItemType ChangeRequest
```

Remove-VSTeamWorkItemType -ProcessTemplate Scrum5 -WorkItemType ChangeRequest.

### Example 2

```powershell
Set-VSTeamWorkItemType -ProcessTemplate Scrum5 -WorkItemType ChangeRequest -Icon icon_parachute -color Blue -Description "For requests from customers"
```

Modifies the custom process "Scrum5", changing a user-defined work item type "ChangeRequest" to use
a blue parachute icon and update its description..
## PARAMETERS


### -Confirm

Prompts you for confirmation before running the cmdlet. Normally the command will prompt for confirmation and -Confirm is only needed if \$ConfirmPreference has been changed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

<!-- #include "./params/force.md" -->

### -ProcessTemplate

The process template to modify. Note that the built-in templates ("Scrum", "Agile" etc.) cannot be modified, only custom templates (derived from the built-in ones) can be changed.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkItemType

The name of the work item type to be removed or reverted. If the WorkItem type is a system type (for example if had been changed but has already been reverted), then an error will be thrown.

The built-in system types cannot be deleted, but can be disabled with Set-VSTeamWorkItemType.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
[Add-VSTeamWorkItemType](Add-VSTeamWorkItemType.md)

[Get-VSTeamWorkItemType](Get-VSTeamWorkItemType.md)

[Set-VSTeamWorkItemType](Remove-VSTeamWorkItemType.md)