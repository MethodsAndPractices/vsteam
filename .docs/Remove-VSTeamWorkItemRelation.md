<!-- #include "./common/header.md" -->

# Remove-VSTeamWorkItemTag

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamWorkItemRelation.md" -->

## SYNTAX

## DESCRIPTION

This cmdlet is a shortcut of Get-VSTeamWorkItem -Id $Id -Expand Relations, and Update-VSTeamWorkItem -Id $Id -Relations $relationsToRemove
Allows easily to remove the relation of 2 workitems just knowing the IDs

## EXAMPLES

### Example 1

```powershell
55, 66 | Remove-VSTeamWorkItemRelation -FromRelatedId 25
```
Imagine 55 and 66 work items are children of 25. This command will remove the Child relationship from 55 to 25 and from 66 to 25

### Example 2

```powershell
Remove-VSTeamWorkItemRelation -Id 25 -FromRelatedId 55, 66
```
Imagine 55 and 66 work items are children of 25. This command will remove the Parent relationship from 25 to 55 and 66


## PARAMETERS

<!-- #include "./params/projectName.md" -->

### Id

Id of the work item

```yaml
Type: Int32[]
Required: True
Accept pipeline input: true (ByPropertyName, ByValue)

```
### FromRelatedId
Id of the related work item
Type: Int32[]
Required: True

## INPUTS

## OUTPUTS
PSObject with the updated work item identified by the Id parameter

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

[Get-VSTeamWorkItem](Get-VSTeamWorkItem.md)
[Get-VSTeamWorkItemRelation](Get-VSTeamWorkItemRelation.md)
[New-VSTeamWorkItemRelation](New-VSTeamWorkItemRelation.md)
[Update-VSTeamWorkItem](Update-VSTeamWorkItem.md)
