<!-- #include "./common/header.md" -->

# Get-VSTeamTfvcBranch

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamTfvcBranch.md" -->

## SYNTAX

## DESCRIPTION

Get-VSTeamTfvcBranch gets a branch for a given path from TFVC source control.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamTfvcBranch -Path $/MyProject/MyBranch
```

This command returns the branch object for the path $/MyProject/MyBranch

### Example 2

```powershell
Get-VSTeamTfvcBranch -Path $/MyProject/MyBranch -IncludeChildren
```

This command returns the branch object for the path $/MyProject/MyBranch and its child branches.

### Example 3

```powershell
Get-VSTeamTfvcBranch -Path $/MyProject/MyBranch -IncludeParent
```

This command returns the branch object for the path $/MyProject/MyBranch and its parent.

### Example 4

```powershell
Get-VSTeamTfvcBranch -Path $/MyProject/MyBranch -IncludeDeleted
```

This command returns the branch object for the path $/MyProject/MyBranch, even if it's marked as deleted.

### Example 5

```powershell
'$/MyProject/MyBranch','$/AnotherProject/AnotherBranch' | Get-VSTeamTfvcBranch
```

This command returns the branch objects for the paths $/MyProject/MyBranch and $/AnotherProject/AnotherBranch by using the pipeline.

### Example 6

```powershell
Get-VSTeamTfvcBranch -ProjectName TestProject
```

This command returns all the branches under a project.

## PARAMETERS

### ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 0
Required: True
Parameter Sets: List
Accept pipeline input: true (ByPropertyName)
```

### Path

Full path to the branch.

```yaml
Type: String[]
Parameter Sets: ByPath
Accept pipeline input: true
```

### IncludeChildren

Return child branches, if there are any.

```yaml
Type: SwitchParameter
```

### IncludeParent

Return the parent branch, if there is one.

```yaml
Type: SwitchParameter
```

### IncludeDeleted

Return branches marked as deleted.

```yaml
Type: SwitchParameter
```

## INPUTS

## OUTPUTS

## NOTES

You can pipe paths to this function.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
