<!-- #include "./common/header.md" -->

# Add-VSTeam

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamWorkItemRelation.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamWorkItemRelation.md" -->

## EXAMPLES

### Example 1: Adds workitems as children

```powershell
50, 51 | Add-VSTeamWorkItemRelation -RelationType Child -OfRelatedId 80
```
This command adds 50 and 51 as child of 80

### Example 2: Adds workitems as children

```powershell
Add-VSTeamWorkItemRelation Id 50,51 -RelationType Child -OfRelatedId 80 
```
This command adds 50 and 51 as child of 80

## PARAMETERS

### Id

IDs of the elements whose relate with RelatedId

```yaml
Type: int[]
Required: True
Position: 0
Accept pipeline input: true (ByPropertyName, ByValue)
```

### RelationType

Specify the relation type. The relation name is translated to the technical name.
You can tab complete from a list of available relation types. Also you can get a list of relation types using the Get-VSTeamWorkItemRelationType CmdLet

```yaml
Type: String
Required: True
Position: 1
```

### OfRelatedId

Id of the related work item
All the work items identified by the IDs will be related with this work item. For example, you cannot specify a -RelationType Parent because the
cmdlet will try to assing all the IDs as parent of the related work item

```yaml
Type: int
Required: True
Position: 2
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

### System.String

Returns the work item identified by OfRelatedId

## NOTES

This cmdlet is a shorcut for New-VSTeamWorkItemRelation and Update-VSTeamWorkItem.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

[Update-VSTeamWorkItem](Update-VSTeamWorkItem.md)
[New-VSTeamWorkItemRelation](New-VSTeamWorkItemRelation.md)
[Switch-VSTeamWorkItemParent](Switch-VSTeamWorkItemParent.md)
