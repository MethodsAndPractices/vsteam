<!-- #include "./common/header.md" -->

# Add-VSTeamProfile

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamProfile.md" -->

## SYNTAX

## DESCRIPTION

## EXAMPLES

### Example 1

```powershell
Add-VSTeamProfile
```

You will be prompted for the account name and personal access token.

### Example 2

```powershell
Add-VSTeamProfile -Account mydemos -PersonalAccessToken 7a8ilh6db4aforlrnrqmdrxdztkjvcc4uhlh5vgbteserp3mziwnga -Version TFS2018
```

Allows you to provide all the information on the command line.

### Example 3

```powershell
Add-VSTeamProfile -Account http://localtfs:8080/tfs/DefaultCollection -UseWindowsAuthentication
```

On Windows, allows you use to use Windows authentication against a local TFS server.

## PARAMETERS

<!-- #include "./params/account.md" -->

### SecurePersonalAccessToken

A secured string to capture your personal access token.

This will allow you to provide your personal access token
without displaying it in plain text.

To use pat simply omit it from the Add-VSTeamProfile command.

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

### UseWindowsAuthentication

Allows the use of the current user's Windows credentials to authenticate against a local TFS.

```yaml
Type: SwitchParameter
Parameter Sets: Windows
```

### UseBearerToken

Switches the authorization from Basic to Bearer.  You still use the PAT for PersonalAccessToken parameters to store the token.

```yaml
Type: SwitchParameter
Parameter Sets: Secure, Plain
```

### Name

Optional name for the profile. If this parameter is not provided the account will also serve as the name.

```yaml
Type: String
Required: True
Position: 3
```

<!-- #include "./params/version.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

[Set-VSTeamAPIVersion](Set-VSTeamAPIVersion.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Set-VSTeamDefaultAPITimeout](Set-VSTeamDefaultAPITimeout.md)

[about_vsteam](about_vsteam)

[about_vsteam_profiles](about_vsteam_profiles)

[about_vsteam_provider](about_vsteam_provider)
