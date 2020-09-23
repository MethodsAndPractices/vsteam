<!-- #include "./common/header.md" -->

# Get-VSTeamQuery

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamQuery.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamQuery.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamQuery MyProject
```

## PARAMETERS

### Depth

In the folder of queries, return child queries and folders to this depth.

```yaml
Type: Int
Default value: 1
```

### Target

Specifies the version to use. The acceptable values for this parameter are:

- all
- clauses
- minimal
- none
- wiql

```yaml
Type: String
Default value: none
```

### IncludeDeleted

Include deleted queries and folders

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### vsteam_lib.Query

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
