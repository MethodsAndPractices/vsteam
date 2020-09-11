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
PS C:\> Show-VSTeamProject TestProject
```

This will open a browser to the TestProject site

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Id

The id of the project to return.

```yaml
Type: String
Parameter Sets: ByID
Aliases: ProjectID
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamProject](Add-VSTeamProject.md)

[Remove-VSTeamProject](Remove-VSTeamProject.md)
