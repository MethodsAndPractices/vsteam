<!-- #include "./common/header.md" -->

# Get-VSTeamQueue

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamQueue.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamQueue.md" -->

## EXAMPLES

### Example 1
```powershell
Get-VSTeamQueue -ProjectName "MyProject"
```

Returns a list of all agent queues for the specified project "MyProject".

### Example 2
```powershell
Get-VSTeamQueue -QueueName "BuildQueue" -ProjectName "MyProject"
```

Returns the agent queue with the name "BuildQueue" for the specified project "MyProject".

### Example 3
```powershell
Get-VSTeamQueue -Id "12345" -ProjectName "MyProject"
```

Returns the agent queue with the specified `Id` "12345" for the project "MyProject".

### Example 4
```powershell
Get-VSTeamQueue -ActionFilter "Manage" -ProjectName "MyProject"
```

Returns the agent queues for the project "MyProject" where the action filter is set to "Manage".

### Example 5
```powershell
Get-VSTeamQueue -ProjectName "MyProject" | Where-Object { $_.QueueName -like "*Test*" }
```

Returns all agent queues for the project "MyProject" where the queue name contains the word "Test".

## PARAMETERS

### QueueName

Name of the queue to return.

```yaml
Type: String
Parameter Sets: List
```

### ActionFilter

None, Manage or Use.

```yaml
Type: String
Parameter Sets: List
```

### Id

Id of the queue to return.

```yaml
Type: String
Parameter Sets: ByID
Aliases: QueueID
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### vsteam_lib.Queue

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
