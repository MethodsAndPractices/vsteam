<!-- #include "./common/header.md" -->

# Get-VSTeamWiql

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamWiql.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamWiql.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamWiql -Query "Select [System.Id], [System.Title], [System.State] From WorkItems" -Team "MyProject Team" -Project "MyProject" -Expand
```

This command gets work items via a WIQL query and expands the return work items with only the selected fields System.Id, System.Title and System.State.

### Example 2

```powershell
Get-VSTeamWiql -Query "Select [System.Id], [System.Title], [System.State] From WorkItems" -Team "MyProject Team" -Project "MyProject"
```

This command gets work items via a WIQL query and returns the WIQL query result with only work item IDs.

## PARAMETERS

### Id

The id query to return work items for. This is the ID of any saved query within a team in a project

```yaml
Type: Int32
Parameter Sets: ByID
Required: True
```

### Query

The WIQL query. For the syntax check [the official documentation](https://docs.microsoft.com/en-us/azure/devops/boards/queries/wiql-syntax?view=azure-devops).

```yaml
Type: String
Parameter Sets: ByQuery
Required: True
```

### Top

The max number of results to return.

```yaml
Type: String
Required: False
Default value: 100
```

### TimePrecision

Whether or not to use time precision.

```yaml
Type: Switch
```

### Expand

The expand the work items with the selected attributes in the WIQL query.

```yaml
Type: Switch
```

## INPUTS

### System.String

ProjectName

## OUTPUTS

## NOTES

If you do not set the default project by called Set-VSTeamDefaultProject you must pass in -ProjectName for the tab completion of names to work.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
