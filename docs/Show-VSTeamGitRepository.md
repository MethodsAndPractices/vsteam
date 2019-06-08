


# Show-VSTeamGitRepository

## SYNOPSIS

Opens the Git repository in the default browser.

## SYNTAX

## DESCRIPTION

Opens the Git repository in the default browser.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Show-VSTeamGitRepository -ProjectName Demo
```

This command opens the Git repository in a browser.

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 0
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -RemoteUrl

The RemoteUrl of the Git repository to open.

```yaml
Type: String
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

