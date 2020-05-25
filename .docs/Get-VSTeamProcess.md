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
PS C:\> Get-VSTeamProcess  | Format-Wide
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

The API now disregards the SKIP and TOP query values, so this parameter is ignored and deprecated. It will be removed in a future version

```yaml
Type: Int32
Parameter Sets: List
Default value: 100
```

### -Skip

The API now disregards the SKIP and TOP query values, so this parameter is ignored and deprecated. It will be removed in a future version


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
