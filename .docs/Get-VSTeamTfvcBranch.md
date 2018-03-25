#include "./common/header.md"

# Get-VSTeamTfvcBranch

## SYNOPSIS

#include "./synopsis/Get-VSTeamTfvcBranch.md"

## SYNTAX

```powershell
Get-VSTeamTfvcBranch [-Path <String[]>] [-IncludeChildren] [-IncludeParent] [-IncludeDeleted]
```

## DESCRIPTION

Get-VSTeamTfvcBranch gets a branch for a given path from TFVC source control.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```powershell
PS C:\> Get-VSTeamTfvcBranch -Path $/MyProject/MyBranch
```

This command returns the branch object for the path $/MyProject/MyBranch

### -------------------------- EXAMPLE 2 --------------------------

```powershell
PS C:\> Get-VSTeamTfvcBranch -Path $/MyProject/MyBranch -IncludeChildren
```

This command returns the branch object for the path $/MyProject/MyBranch and its child branches. 

### -------------------------- EXAMPLE 3 --------------------------

```powershell
PS C:\> Get-VSTeamTfvcBranch -Path $/MyProject/MyBranch -IncludeParent
```

This command returns the branch object for the path $/MyProject/MyBranch and its parent. 

### -------------------------- EXAMPLE 4 --------------------------

```powershell
PS C:\> Get-VSTeamTfvcBranch -Path $/MyProject/MyBranch -IncludeDeleted
```

This command returns the branch object for the path $/MyProject/MyBranch, even if it's marked as deleted.

### -------------------------- EXAMPLE 5 --------------------------

```powershell
PS C:\> '$/MyProject/MyBranch','$/AnotherProject/AnotherBranch' | Get-VSTeamTfvcBranch
```

This command returns the branch objects for the paths $/MyProject/MyBranch and $/AnotherProject/AnotherBranch by using the pipeline.

## PARAMETERS

### -Path

Full path to the branch.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value:
Accept pipeline input: True
Accept wildcard characters: False
```

### -IncludeChildren

Return child branches, if there are any.

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

### -IncludeParent

Return the parent branch, if there is one.

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

Return branches marked as deleted.

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

You can pipe paths to this function.

## RELATED LINKS