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
New-VSTeamWorkItemRelation -RelationType Duplicate -Id 55 -Operation Remove -Comment "not needed"

Id RelationType                       Operation Comment
-- ------------                       --------- -------
55 System.LinkTypes.Duplicate-Forward remove    not needed
```

Simple invocation, returns a Relation object.


### Example 2

```powershell
$relations = New-VSTeamWorkItemRelation -RelationType Related -Operation Remove -Id 55 |
    New-VSTeamWorkItemRelation -RelationType Related -Operation Remove -Id 66 |
    New-VSTeamWorkItemRelation -RelationType Related -Operation Remove -Id 77 |
Update-VSTeamWorkItem -Id 30 -Relations $relations
```
Removes work items 55, 66 and 77 relations from work item 30

### Example 3

```powershell
$relations =@()
$relations += New-VSTeamWorkItemRelation -RelationType Related -Id 55 -Operation Remove
$relations += New-VSTeamWorkItemRelation -RelationType Related -Id 66 -Operation Add
Update-VSTeamWorkItem -Id 30 -Relations $relations
```
Similar to example 2, but managing the relations collection directly

### Example 4

```powershell
$relations = 55,66 | New-VSTeamWorkItemRelation -RelationType Child -Operation Add
Update-VSTeamWorkItem -Id 30 -Relations $relations

```
Adds work items 55 and 56 as children of 30

### Example 5

```powershell
$relations = Get-VSTeamWorkItem -Id 55 | New-VSTeamWorkItemRelation -RelationType Duplicate -Operation Add -Comment "is it dupllicate?"
Update-VSTeamWorkItem -Id 30 -Relations $relations

```
Adds work items 55 as duplicate of 30

### Example 6

```powershell
$relations = Get-VSTeamWiql -Id "f87b028b-0528-47d6-b517-2d82af680295" | 
  Select-Object -ExpandProperty WorkItems |
  New-VSTeamWorkItemRelation -RelationType Related
Update-VSTeamWorkItem -Id 30 -Relations $relations
```
Adds all work items returned by a query as related to work item 30

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

Intended for fluent pipeline (see Example 2)

```yaml
Type: String
Parameter Sets: ByRelation
Required: True
```

### RelationType

Relation type name

You can tab complete from a list of available relation types. Also you can get a list of relation types using the Get-VSTeamWorkItemRelationType CmdLet

```yaml
Type: string
Required: True
```

### Operation

Add a relation or Remove a relation or Replace a relation

```yaml
Type: string
Required: False
Default value: Add
Accepted values: Add, Remove, Replace
```

### Comment

Add a comment to the relation

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