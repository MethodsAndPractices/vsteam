


# Remove-VSTeamAccount

## SYNOPSIS

Clears your default project, account name and personal access token.

## SYNTAX

## DESCRIPTION

Clears the environment variables that hold your default project, account, bearer token and personal access token. You have to run Set-VSTeamAccount again before calling any other functions.

To remove from the Machine level you must be running PowerShell as administrator.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Remove-VSTeamAccount
```

This will clear your account name and personal access token.

## PARAMETERS

### -Level

On Windows allows you to clear your account information at the Process, User or Machine levels.

```yaml
Type: String
```

### -Force

Forces the function without confirmation

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

