


# Get-VSTeamTfvcBranch

## SYNOPSIS

Gets a branch for a given path from TFVC source control.

## SYNTAX

## DESCRIPTION

Get-VSTeamTfvcBranch gets a branch for a given path from TFVC source control.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamTfvcBranch -Path $/MyProject/MyBranch
```

This command returns the branch object for the path $/MyProject/MyBranch

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamTfvcBranch -Path $/MyProject/MyBranch -IncludeChildren
```

This command returns the branch object for the path $/MyProject/MyBranch and its child branches.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Get-VSTeamTfvcBranch -Path $/MyProject/MyBranch -IncludeParent
```

This command returns the branch object for the path $/MyProject/MyBranch and its parent.

### -------------------------- EXAMPLE 4 --------------------------

```PowerShell
PS C:\> Get-VSTeamTfvcBranch -Path $/MyProject/MyBranch -IncludeDeleted
```

This command returns the branch object for the path $/MyProject/MyBranch, even if it's marked as deleted.

### -------------------------- EXAMPLE 5 --------------------------

```PowerShell
PS C:\> '$/MyProject/MyBranch','$/AnotherProject/AnotherBranch' | Get-VSTeamTfvcBranch
```

This command returns the branch objects for the paths $/MyProject/MyBranch and $/AnotherProject/AnotherBranch by using the pipeline.

## PARAMETERS

### -Path

Full path to the branch.

```yaml
Type: String[]
Accept pipeline input: true
```

### -IncludeChildren

Return child branches, if there are any.

```yaml
Type: SwitchParameter
```

### -IncludeParent

Return the parent branch, if there is one.

```yaml
Type: SwitchParameter
```

### -IncludeDeleted

Return branches marked as deleted.

```yaml
Type: SwitchParameter
```

## INPUTS

## OUTPUTS

## NOTES

You can pipe paths to this function.

## RELATED LINKS

