<!-- #include "./common/header.md" -->

# Remove-VSTeamWorkItem

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamWorkItem.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamWorkItem.md" -->

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

<!-- #include "./params/force.md" -->

<!-- #include "./params/confirm.md" -->

<!-- #include "./params/whatif.md" -->

## INPUTS

### System.String

ProjectName

## OUTPUTS

## NOTES

If you do not set the default project by called Set-VSTeamDefaultProject before calling Get-VSTeamWorkItem you will have to type in the names.

## RELATED LINKS
