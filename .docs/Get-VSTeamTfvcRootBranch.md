#include "./common/header.md"

# Get-VSTeamTfvcRootBranch

## SYNOPSIS

#include "./synopsis/Get-VSTeamTfvcRootBranch.md"

## SYNTAX

```powershell
Get-VSTeamTfvcRootBranch [-IncludeChildren] [-IncludeDeleted]
```

## DESCRIPTION

Get-VSTeamTfvcRootBranch gets root branches for all projects with TFVC source control.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```powershell
PS C:\> Get-VSTeamTfvcRootBranch
```

This command returns root branches for all projects.

### -------------------------- EXAMPLE 2 --------------------------

```powershell
PS C:\> Get-VSTeamTfvcRootBranch -IncludeChildren
```

This command returns root branches for all projects and their respective child branches.

### -------------------------- EXAMPLE 3 --------------------------

```powershell
PS C:\> Get-VSTeamTfvcRootBranch -IncludeDeleted
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