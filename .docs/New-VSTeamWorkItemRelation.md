<!-- #include "./common/header.md" -->

# New-VSTeamWorkItemRelation

## SYNOPSIS

<!-- #include "./synopsis/New-VSTeamWorkItemRelation.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/New-VSTeamWorkItemRelation.md" -->

## EXAMPLES

### Example 1

```powershell
New-VSTeamWorkItemRelation -RelationType Duplicate -Id 55 -Comment "My comment"

ID RelationType                       Operation Index Comment
-- ------------                       --------- ----- -------
55 System.LinkTypes.Hierarchy-Reverse add       -     My comment
```
Simple invocation, returns a Relation object.


### Example 2

```powershell
$relations = New-VSTeamWorkItemRelation -Operation Remove -Index 0 |
             New-VSTeamWorkItemRelation -Operation Remove -Index 1 
Update-VSTeamWorkItem -Id 30 -Relations $relations
```
Removes work first 2 links from work item 30

### Example 3

```powershell
$relations =@()
$relations += New-VSTeamWorkItemRelation -Operation Remove -Index 0
$relations += New-VSTeamWorkItemRelation -RelationType Related -Id 66
Update-VSTeamWorkItem -Id 30 -Relations $relations
```
Similar to example 2, but managing the relations collection directly
Pay attention that the first relation, for Operation Remove, only the Index parameter is provided.
In the second relation, when provided the Id, it's necessary to provide the RealationType. The operation will be always Add.

### Example 4

```powershell
$relations = 55,66 | New-VSTeamWorkItemRelation -RelationType Child
Update-VSTeamWorkItem -Id 30 -Relations $relations

```
Adds work items 55 and 56 as children of 30
Pay attention that this use case, passing a list of IDs from pipeline, has sense only for 'Add' operation, and because this is the defaut operation value, we can ommit the Operation parameter

### Example 5

```powershell
$relations = Get-VSTeamWorkItem -Id 55 | New-VSTeamWorkItemRelation -RelationType Duplicate -Comment "is it dupllicate?"
Update-VSTeamWorkItem -Id 30 -Relations $relations

```
Adds work items 55 as duplicate of 30
Pay attention that this use case, passing a list of work items from pipeline, has sense only for 'Add' operation, and because this is the defaut operation value and the Operation parameter is not allowed when you provide the Id

### Example 6

```powershell
$relations = Get-VSTeamWiql -Id "f87b028b-0528-47d6-b517-2d82af680295" | 
  Select-Object -ExpandProperty WorkItems |
  New-VSTeamWorkItemRelation -RelationType Related
Update-VSTeamWorkItem -Id 30 -Relations $relations
```
Adds all work items returned by a query as related to work item 30
Pay attention that this use case, passing a list of work items from pipeline, has sense only for 'Add' operation, and because this is the defaut operation value, we can ommit the Operation parameter

### Example 7
```powershell
$relation = New-VSTeamWorkItemRelation -RelationType Related -Operation Replace -Comment "updated comment"
Update-VSTeamWorkItem -Id 30 -Relations $relations
```
Updates the comment of a relation. The replace operation only supports comment update. 
If you really need to change a relation, like re-parent a work item, you need to create two relations: first, remove and then add operations.

### Example 8
```powershell
$relations =@()
$id = Get-VSTeamWorkItem -id 30 -Expand Relation
for ($i=0; $i -lt $id.relations.Count; $i++) { 
  $relations += New-VSTeamWorkItemRelation -Operation Remove -Index $i
}
Update-VSTeamWorkItem -Id 30 -Relations $relations
```
Removes all the links from work item 30

## PARAMETERS

### ImputObject

Operation: Intended for fluent syntax (see Example 2)

```yaml
Type: PSCustomObject[]
Parameter Sets: ByObject
Required: True
Accept pipeline input: true
```

### Id

Related WorkItem id

This is not the work item to be updated, but the work item that will be part of the relations of the updated work item
Can be used as parameter or pass a list of ID's or a list of work items from the pipeline

```yaml
Type: int[]
Parameter Sets: ByID,ByObject
Required: True
Accept pipeline input: true
```

### RelationType

Specify the relation type. The relation name is translated to the technical name.
You can tab complete from a list of available relation types. Also you can get a list of relation types using the Get-VSTeamWorkItemRelationType CmdLet
Not allowed when you specify an index in the remove or replace operations

```yaml
Type: String
Parameter Sets: ByID,ByRelation
Required: True (in ByID parameterset)
```

### Operation

Remove or Replace a relation
The Add operation is implicit when the Id parameter is used. So this parameter is only valid when Index is specified

```yaml
Type: string
Parameter Sets: ByIndex,ByRelation
Required: False
Accepted values: Remove, Replace
```

### Comment

Add (or edit -with Replace operation-) a comment to the relation

```yaml
Type: string
Required: False
```

## OUTPUTS

### vsteam_lib.WorkItemRelation

## NOTES

This CmdLet do not modify any work item, just generates a JSON Patch compatible object that describes the updates to be applied using the Update-VSTeamWorkItem

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

[Get-VSTeamWorkItemRelationType](Get-VSTeamWorkItemRelationType.md)
[Get-VSTeamWorkItem](Get-VSTeamWorkItem.md)
[Update-VSTeamWorkItem](Update-VSTeamWorkItem.md)