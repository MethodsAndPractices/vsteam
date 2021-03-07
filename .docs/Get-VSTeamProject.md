<!-- #include "./common/header.md" -->

# Get-VSTeamProject

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamProject.md" -->

## SYNTAX

## DESCRIPTION

The list of projects returned can be controlled by using the stateFilter, top and skip parameters.

You can also get a single project by name or id.

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamProject
```

This will return all the WellFormed team projects.

### Example 2

```powershell
Get-VSTeamProject -top 5 | Format-Wide
```

This will return the top five WellFormed team projects only showing their name

## PARAMETERS

### StateFilter

Returns team projects in a specific team project state.  The acceptable values for this parameter are:

- WellFormed
- CreatePending
- Deleting
- New
- All

```yaml
Type: String
Parameter Sets: List
Default value: WellFormed
```

### Top

Specifies the maximum number to return.

```yaml
Type: Int32
Parameter Sets: List
```

### Skip

Defines the number of team projects to skip. The default value is 0

```yaml
Type: Int32
Parameter Sets: List
```

### Id

The id of the project to return.

```yaml
Type: String
Parameter Sets: ByID
Aliases: ProjectID
```

### IncludeCapabilities

Will return additional information about the project.

```yaml
Type: SwitchParameter
Parameter Sets: ByID
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

## NOTES

You can use PowerShell default values to set top to any value you like.

$Global:PSDefaultParameterValues["*-vsteam*:top"] = 500

However, this function is called by the Project cache which is used by the project validation code. If the value of top is not high enough validation may fail. By default this function returns all projects.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamProject](Add-VSTeamProject.md)

[Remove-VSTeamProject](Remove-VSTeamProject.md)
