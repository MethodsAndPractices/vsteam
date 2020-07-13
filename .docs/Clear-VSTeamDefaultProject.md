<!-- #include "./common/header.md" -->

# Clear-VSTeamDefaultProject

## SYNOPSIS

<!-- #include "./synopsis/Clear-VSTeamDefaultProject.md" -->

## SYNTAX

## DESCRIPTION

Clears the value stored in the default project parameter value.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Clear-VSTeamDefaultProject
```

This will clear the default project parameter value. You will now have to provide a project for any functions that require a project.

## PARAMETERS

### -Level

On Windows allows you to clear your default project at the Process, User or Machine levels.

```yaml
Type: String
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Set-VSTeamAccount](Set-VSTeamAccount.md)
