<!-- #include "./common/header.md" -->

# Remove-VSTeamAccount

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamAccount.md" -->

## SYNTAX

## DESCRIPTION

Clears the environment variables that hold your default project, account, bearer token and personal access token. You have to run Set-VSTeamAccount again before calling any other functions.

To remove from the Machine level you must be running PowerShell as administrator.

## EXAMPLES

### Example 1

```powershell
Remove-VSTeamAccount
```

This will clear your account name and personal access token.

## PARAMETERS

### Level

On Windows allows you to clear your account information at the Process, User or Machine levels.

```yaml
Type: String
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
