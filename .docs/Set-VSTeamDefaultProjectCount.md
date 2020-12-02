<!-- #include "./common/header.md" -->

# Set-VSTeamDefaultProjectCount

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamDefaultProjectCount.md" -->

## SYNTAX

## DESCRIPTION

The majority of the functions in this module require a project name and you can tab complete it. Each project name if validated before used in a function call.

By setting a default project count you can make sure all your projects are returned during tab completion and project name parameter validation if you have more than 100 projects.

## EXAMPLES

### Example 1

```powershell
Set-VSTeamDefaultProjectCount 500
```

This command sets 500 as the default project count to return.

## PARAMETERS

### Count

Specifies the number of projects to return by default.

```yaml
Type: int
Required: True
Accept pipeline input: true (ByPropertyName)
```

### Level

On Windows allows you to store your default project count at the Process, User or Machine levels.

When saved at the User or Machine level your default project count will be in any future PowerShell processes.

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
