#include "./common/header.md"

# Get-VSTeamTfvcRootBranches

## SYNOPSIS
#include "./synopsis/Get-VSTeamTfvcRootBranches.md"

## SYNTAX
```
Get-VSTeamTfvcRootBranches [-IncludeChildren] [-IncludeDeleted]
```

## DESCRIPTION
Get-VSTeamTfvcRootBranches gets root branches for all projects with TFVC source control.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-VSTeamTfvcRootBranches
```

This command returns root branches for all projects.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Get-VSTeamTfvcRootBranches -IncludeChildren
```

This command returns root branches for all projects and their respective child branches. 

### -------------------------- EXAMPLE 3 --------------------------
```
PS C:\> Get-VSTeamTfvcRootBranches -IncludeDeleted
```

This command returns root branches for all projects, also those marked as deleted. 

## PARAMETERS

### -IncludeChildren

Return the child branches for each root branch.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeDeleted

Return deleted branches.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS