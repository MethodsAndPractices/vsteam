<!-- #include "./common/header.md" -->

# Get-VSTeamProcess

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamProcess.md" -->

## SYNTAX

## DESCRIPTION

The list of Process Templates can be filtered by name  (which may include Wildcard). You can also get a single Process Template by id

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamProcess
```

This will return all the Process Templates

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamProcess | Format-Wide
```

This will return the Process Templates only showing their name

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Get-VSTeamProcess *scrum*
```

This will return an process templates with names containing scrum,
in other words, the default "Scrum" template and custom ones with
names like "Custom Scrum", "Scrum for Contoso" will all be returned.

## PARAMETERS

<!-- #include "./params/ProcessName.md" -->

### -Top

Specifies the maximum number to return.
If -Skip is specified and -Top is omitted the next 100 will be returned.
If neither Skip nor -Top is specified, all process templates will be returned.

```yaml
Type: Int32
Parameter Sets: List
Default value: 100
```

### -Skip

Defines the number of Process Templates to skip.
If -Top is specified and -Skip is omitted none will be skipped.
If neither Skip nor -Top is specified, all process templates will be returned.

```yaml
Type: Int32
Parameter Sets: List
Default value: 0
```

### -Id

The id of the Process Template to return.

```yaml
Type: String
Parameter Sets: ByID
Aliases: ProcessID
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Add-VSTeamProject](Add-VSTeamProject.md)
