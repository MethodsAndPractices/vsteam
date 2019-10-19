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
PS C:\> Remove-VSTeamWorkItem -Ids 47,48
```

This command deletes work items with IDs 47 and 48 by using the IDs parameter.

```PowerShell
PS C:\> Remove-VSTeamWorkItem -Id 47
```

This command deletes the work item with ID 47 by using the ID parameter.

```PowerShell
PS C:\> Remove-VSTeamWorkItem -Ids 47 -Destroy
```

This command deletes work item with IDs 47 **permanently** by using the Destroy parameter.

## PARAMETERS

### -Id

The id of the work item.

```yaml
Type: Int32
Parameter Sets: ByID
Required: True
Accept pipeline input: true (ByPropertyName, ByValue)
```

### -Ids

The id of the work item.

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

## INPUTS

### System.String

ProjectName

## OUTPUTS

## NOTES

If you do not set the default project by called Set-VSTeamDefaultProject before calling Get-VSTeamWorkItem you will have to type in the names.

## RELATED LINKS
