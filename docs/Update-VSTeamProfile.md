


# Update-VSTeamProfile

## SYNOPSIS

Allows you to update the Personal Access Token for your profile.

## SYNTAX

## DESCRIPTION

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Update-VSTeamProfile -Name ProfileName
```

You will be prompted for the account name and personal access token.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Update-VSTeamProfile -Name mydemos -PersonalAccessToken 7a8ilh6db4aforlrnrqmdrxdztkjvcc4uhlh5vgbteserp3mziwnga
```

Allows you to provide all the information on the command line.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Get-VSTeamProfile | Where-Object version -eq vsts | Select-Object -skip 1 | Update-VSTeamProfile -PersonalAccessToken 7a8ilh6db4aforlrnrqmdrxdztkjvcc4uhlh5vgbteserp3mziwnga -Force
```

This will update all but the first AzD profile

## PARAMETERS

### -PAT

A secured string to capture your personal access token.

This will allow you to provide your personal access token
without displaying it in plain text.

To use pat simply omit it from the Update-VSTeamProfile command.

```yaml
Type: SecureString
Parameter Sets: Secure
Required: True
```

### -PersonalAccessToken

The personal access token from AzD/TFS to use to access this account.

```yaml
Type: String
Parameter Sets: Plain
Required: True
Position: 2
```

### -Name

Name of the profile to be updated

```yaml
Type: String
Required: True
Position: 3
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

[Update-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

