<!-- #include "./common/header.md" -->

# Set-VSTeamDefaultProject

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamDefaultProject.md" -->

## SYNTAX

## DESCRIPTION

The majority of the functions in this module require a project name.

By setting a default project you can omit that parameter from your function calls and this default will be used instead.

## EXAMPLES

### Example 1

```powershell
Set-VSTeamDefaultProject Demo
```

This command sets Demo as the default project.

You can now call other functions that require a project name without passing the project.

## PARAMETERS

### Project

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

```yaml
Type: String
Required: True
Accept pipeline input: true (ByPropertyName)
```

### Level

On Windows allows you to store your default project at the Process, User or Machine levels.

When saved at the User or Machine level your default project will be in any future PowerShell processes.

```yaml
Type: String
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
