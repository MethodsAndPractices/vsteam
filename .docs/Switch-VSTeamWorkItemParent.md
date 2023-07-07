<!-- #include "./common/header.md" -->

# Add-VSTeam

## SYNOPSIS

<!-- #include "./synopsis/Switch-VSTeamWorkItemParent.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Switch-VSTeamWorkItemParent.md" -->

## EXAMPLES

### Example 1: Replace the paretn in 2 work items

```powershell
50, 51 | Switch-VSTeamWorkItemParent -ParentId 80
```
This command replaces the parent in workitems with ID 50 and 51 and assign work item 80 as parent
If any of the IDs provided don't have a parent, they shall remain they are.

### Example 2: Replace the paretn in 2 work items

```powershell
Switch-VSTeamWorkItemParent Id 50,51 -ParentId 80 -AddParent
```
This command replaces the parent in workitems with ID 50 and 51 and assign work item 80 as parent
If any of the IDs provided don't have a parent, the work item 80 is assigned

## PARAMETERS

### Id

IDs of the elements whose parent is to be replaced

```yaml
Type: int[]
Required: True
Position: 0
Accept pipeline input: true (ByPropertyName, ByValue)
```

### ParentId

Id of the new parent work item

```yaml
Type: int
Required: True
Position: 1
```

### AddParent

If present, if the work item currently doen't have a parent, it will assign $ParentId as parent
If not present, if the work item currently doen't have a parent, it shall remain as is.

```yaml
Type: switch
Required: False
Position: 3
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

[Get-VSTeam](Get-VSTeamUpdateWorkItem.md)
[Remove-VSTeam](New-VSTeamWorkItemRelation.md)
