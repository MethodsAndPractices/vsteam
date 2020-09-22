<!-- #include "./common/header.md" -->

# Get-VSTeamProcess

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamProcess.md" -->

## SYNTAX

## DESCRIPTION

The list of Process Templates can be filtered by name  (which may include Wildcard). You can also get a single Process Template by id

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### Example 1

```powershell
Get-VSTeamProcess
```

This will return all the Process Templates

### Example 2

```powershell
Get-VSTeamProcess | Format-Wide
```

This will return the Process Templates only showing their name

### Example 3

```powershell
Get-VSTeamProcess *scrum*
```

This will return an process templates with names containing scrum,
in other words, the default "Scrum" template and custom ones with
names like "Custom Scrum", "Scrum for Contoso" will all be returned.

## PARAMETERS

<!-- #include "./params/ProcessName.md" -->

### Id

The id of the Process Template to return.

```yaml
Type: String
Parameter Sets: ByID
Aliases: ProcessID
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamProject](Add-VSTeamProject.md)
