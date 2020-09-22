<!-- #include "./common/header.md" -->

# Update-VSTeamProfile

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamProfile.md" -->

## SYNTAX

## DESCRIPTION

## EXAMPLES

### Example 1

```powershell
Update-VSTeamProfile -Name ProfileName
```

You will be prompted for the account name and personal access token.

### Example 2

```powershell
Update-VSTeamProfile -Name mydemos -PersonalAccessToken 7a8ilh6db4aforlrnrqmdrxdztkjvcc4uhlh5vgbteserp3mziwnga
```

Allows you to provide all the information on the command line.

### Example 3

```powershell
Get-VSTeamProfile | Where-Object version -eq vsts | Select-Object -skip 1 | Update-VSTeamProfile -PersonalAccessToken 7a8ilh6db4aforlrnrqmdrxdztkjvcc4uhlh5vgbteserp3mziwnga -Force
```

This will update all but the first AzD profile

## PARAMETERS

### PAT

A secured string to capture your personal access token.

This will allow you to provide your personal access token
without displaying it in plain text.

To use pat simply omit it from the Update-VSTeamProfile command.

```yaml
Type: SecureString
Parameter Sets: Secure
Required: True
```

### PersonalAccessToken

The personal access token from AzD/TFS to use to access this account.

```yaml
Type: String
Parameter Sets: Plain
Required: True
Position: 2
```

### Name

Name of the profile to be updated

```yaml
Type: String
Required: True
Position: 3
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Update-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)
