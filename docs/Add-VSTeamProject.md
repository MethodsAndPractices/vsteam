


# Add-VSTeamProject

## SYNOPSIS

Adds a Team Project to your account.

## SYNTAX

## DESCRIPTION

This will create a new Team Project in your Team Foundation Server or Team Services account.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Add-VSTeamProject 'MyProject'
```

This will add a project name MyProject with no description using the Scrum process
template and Git source control.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Add-VSTeamProject 'MyProject' -TFVC -ProcessTemplate Agile
```

This will add a project name MyProject with no description using the Agile process
template and TFVC source control.

## PARAMETERS

### -ProjectName

The name of the project to create.

```yaml
Type: String
Aliases: Name
Required: True
Position: 0
```

### -ProcessTemplate

The name of the process template to use for the project.

You can tab complete from a list of available projects.

```yaml
Type: String
Default value: Scrum
```

### -Description

The description of the team project.

```yaml
Type: String
```

### -TFVC

Switches the source control from Git to TFVC.

```yaml
Type: SwitchParameter
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Remove-VSTeamProject](Remove-VSTeamProject.md)

[Get-VSTeamProcess](Get-VSTeamProcess.md)

