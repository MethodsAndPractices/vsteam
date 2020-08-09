


# Get-VSTeamQuery

## SYNOPSIS

Gets the root queries and their children.

## SYNTAX

## DESCRIPTION

Gets the root queries and their children.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamQuery MyProject
```

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 0
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -Depth

In the folder of queries, return child queries and folders to this depth.

```yaml
Type: Int
Default value: 1
```

### -Target

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

### -IncludeDeleted

Include deleted queries and folders

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
```

## INPUTS

## OUTPUTS

### Team.Query

## NOTES

## RELATED LINKS

