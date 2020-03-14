


# Get-VSTeamWiqlItem

## SYNOPSIS

Returns work items from the given WIQL query or a saved query by ID from your projects team.

## SYNTAX

## DESCRIPTION

Returns work items from the given WIQL query or a saved query by ID from your projects team.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamWiql -Query "Select [System.Id], [System.Title], [System.State] From WorkItems" -Team "MyProject Team" -Project "MyProject" -Expand
```

This command gets work items via a WIQL query and expands the return work items with only the selected fields System.Id, System.Title and System.State.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamWiql -Query "Select [System.Id], [System.Title], [System.State] From WorkItems" -Team "MyProject Team" -Project "MyProject"
```

This command gets work items via a WIQL query and returns the WIQL query result with only work item IDs.

## PARAMETERS

### -Id

The id query to return work items for. This is the ID of any saved query within a team in a project

```yaml
Type: Int32
Parameter Sets: ByID
Required: True
```

### -Query

The WIQL query. For the syntax check [the official documentation](https://docs.microsoft.com/en-us/azure/devops/boards/queries/wiql-syntax?view=azure-devops).

```yaml
Type: String
Parameter Sets: ByQuery
Required: True
```

### -Top

The max number of results to return.

```yaml
Type: String
Required: False
Default value: 100
```

### -TimePrecision

Whether or not to use time precision.

```yaml
Type: Switch
```

### -Expand

The expand the work items with the selected attributes in the WIQL query.

```yaml
Type: Switch
```

## INPUTS

### System.String

ProjectName

## OUTPUTS

## NOTES

If you do not set the default project by called Set-VSTeamDefaultProject before calling Get-VSTeamWiql you will have to type in the names.

## RELATED LINKS

