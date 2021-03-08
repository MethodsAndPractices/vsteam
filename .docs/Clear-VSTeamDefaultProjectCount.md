<!-- #include "./common/header.md" -->

# Clear-VSTeamDefaultProjectCount

## SYNOPSIS

<!-- #include "./synopsis/Clear-VSTeamDefaultProjectCount.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Clear-VSTeamDefaultProjectCount.md" -->

Clearing this value will only return the top 100 projects. This could have a negative effect on project name tab completion and validation if you have more than 100 projects.

## EXAMPLES

### Example 1

```powershell
Clear-VSTeamDefaultProjectCount
```

This will clear the default project count parameter value. You will now only get the top 100 projects back.

## PARAMETERS

### Level

On Windows allows you to clear your default project at the Process, User or Machine levels.

```yaml
Type: String
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
