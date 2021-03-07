<!-- #include "./common/header.md" -->

# Add-VSTeamProject

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamProject.md" -->

## SYNTAX

## DESCRIPTION

This will create a new Team Project in your Team Foundation Server or Team Services account.

## EXAMPLES

### Example 1

```powershell
Add-VSTeamProject 'MyProject'
```

This will add a project name MyProject with no description using the Scrum process
template and Git source control.

### Example 2

```powershell
Add-VSTeamProject 'MyProject' -TFVC -ProcessTemplate Agile
```

This will add a project name MyProject with no description using the Agile process
template and TFVC source control.

## PARAMETERS

### ProjectName

The name of the project to create.

```yaml
Type: String
Aliases: Name
Required: True
Position: 0
```

### ProcessTemplate

The name of the process template to use for the project.

You can tab complete from a list of available projects.

```yaml
Type: String
Default value: Scrum
```

### Description

The description of the team project.

```yaml
Type: String
```

### TFVC

Switches the source control from Git to TFVC.

```yaml
Type: SwitchParameter
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Remove-VSTeamProject](Remove-VSTeamProject.md)

[Get-VSTeamProcess](Get-VSTeamProcess.md)
