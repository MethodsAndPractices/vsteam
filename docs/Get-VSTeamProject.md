


# Get-VSTeamProject

## SYNOPSIS

Returns a list of projects in the Team Services or Team Foundation Server account.

## SYNTAX

## DESCRIPTION

The list of projects returned can be controlled by using the stateFilter, top and skip parameters.

You can also get a single project by name or id.

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamProject
```

This will return all the WellFormed team projects.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamProject -top 5 | Format-Wide
```

This will return the top five WellFormed team projects only showing their name

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

### -StateFilter

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

### -Top

Specifies the maximum number to return.

```yaml
Type: Int32
Parameter Sets: List
Default value: 100
```

### -Skip

Defines the number of team projects to skip. The default value is 0

```yaml
Type: Int32
Parameter Sets: List
Default value: 0
```

### -Id

The id of the project to return.

```yaml
Type: String
Parameter Sets: ByID
Aliases: ProjectID
```

### -IncludeCapabilities

Will return additional information about the project.

```yaml
Type: SwitchParameter
Parameter Sets: ByID
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Add-VSTeamProject](Add-VSTeamProject.md)

[Remove-VSTeamProject](Remove-VSTeamProject.md)

