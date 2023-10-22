<!-- #include "./common/header.md" -->

# Show-VSTeamProject

## SYNOPSIS

<!-- #include "./synopsis/Show-VSTeamProject.md" -->

## SYNTAX

## DESCRIPTION

Opens the project in default browser.

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### Example 1

```powershell
Show-VSTeamProject TestProject
```

This will open a browser to the TestProject site

## PARAMETERS

### Id

The id of the project to return.

```yaml
Type: String
Parameter Sets: ByID
Aliases: ProjectID
```

### Name

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: Named
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Add-VSTeamProject](Add-VSTeamProject.md)

[Remove-VSTeamProject](Remove-VSTeamProject.md)
