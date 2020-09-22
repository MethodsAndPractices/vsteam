<!-- #include "./common/header.md" -->

# Get-VSTeamTfvcRootBranch

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamTfvcRootBranch.md" -->

## SYNTAX

## DESCRIPTION

Get-VSTeamTfvcRootBranch gets root branches for all projects with TFVC source control.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamTfvcRootBranch
```

This command returns root branches for all projects.

### Example 2

```powershell
Get-VSTeamTfvcRootBranch -IncludeChildren
```

This command returns root branches for all projects and their respective child branches.

### Example 3

```powershell
Get-VSTeamTfvcRootBranch -IncludeDeleted
```

This command returns root branches for all projects, also those marked as deleted.

## PARAMETERS

### IncludeChildren

Return the child branches for each root branch.

```yaml
Type: SwitchParameter
```

### IncludeDeleted

Return deleted branches.

```yaml
Type: SwitchParameter
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
