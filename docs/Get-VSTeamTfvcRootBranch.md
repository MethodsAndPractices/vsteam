


# Get-VSTeamTfvcRootBranch

## SYNOPSIS

Gets root branches for all projects with TFVC source control.

## SYNTAX

## DESCRIPTION

Get-VSTeamTfvcRootBranch gets root branches for all projects with TFVC source control.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamTfvcRootBranch
```

This command returns root branches for all projects.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamTfvcRootBranch -IncludeChildren
```

This command returns root branches for all projects and their respective child branches.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Get-VSTeamTfvcRootBranch -IncludeDeleted
```

This command returns root branches for all projects, also those marked as deleted.

## PARAMETERS

### -IncludeChildren

Return the child branches for each root branch.

```yaml
Type: SwitchParameter
```

### -IncludeDeleted

Return deleted branches.

```yaml
Type: SwitchParameter
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

