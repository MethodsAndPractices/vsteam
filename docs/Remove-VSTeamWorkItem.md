


# Remove-VSTeamWorkItem

## SYNOPSIS

Deletes the specified work item and sends it to the Recycle Bin, so that it can be restored back, if required. Optionally, if the destroy parameter has been set to true, it destroys the work item permanently. WARNING: If the destroy parameter is set to true, work items deleted by this command will NOT go to recycle-bin and there is no way to restore/recover them after deletion. It is recommended NOT to use this parameter. If you do, please use this parameter with extreme caution.

## SYNTAX

## DESCRIPTION

Deletes the specified work item and sends it to the Recycle Bin, so that it can be restored back, if required. Optionally, if the destroy parameter has been set to true, it destroys the work item permanently. WARNING: If the destroy parameter is set to true, work items deleted by this command will NOT go to recycle-bin and there is no way to restore/recover them after deletion. It is recommended NOT to use this parameter. If you do, please use this parameter with extreme caution.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Remove-VSTeamWorkItem -Id 47,48 -Force
```

This command deletes work items with IDs 47 and 48 by using the IDs parameter.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Remove-VSTeamWorkItem -Id 47
```

This command deletes the work item with ID 47 by using the ID parameter.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Remove-VSTeamWorkItem -Id 47 -Destroy -Force
```

This command deletes work item with IDs 47 **permanently** by using the Destroy parameter.

## PARAMETERS

### -Id

The id of one or more work items.

```yaml
Type: Int32[]
Parameter Sets: List
Required: True
Accept pipeline input: true (ByPropertyName, ByValue)
```

### -Destroy

Optional parameter, if set to true, the work item is deleted permanently. **Please note: the destroy action is PERMANENT and cannot be undone.**

```yaml
Type: Switch
```

### -Force

Forces the function without confirmation

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
```

### -Confirm

Prompts you for confirmation before running the function.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
Aliases: cf
```

### -WhatIf

Shows what would happen if the function runs.
The function is not run.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
Aliases: wi
```

## INPUTS

### System.String

ProjectName

## OUTPUTS

## NOTES

If you do not set the default project by called Set-VSTeamDefaultProject before calling Get-VSTeamWorkItem you will have to type in the names.

## RELATED LINKS

