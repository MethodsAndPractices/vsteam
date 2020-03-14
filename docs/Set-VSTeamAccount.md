


# Set-VSTeamAccount

## SYNOPSIS

Stores your account name and personal access token for use with the other
functions in this module.

## SYNTAX

## DESCRIPTION

On Windows you have to option to store the information at the process, user or machine (you must be running PowerShell as administrator to store at the machine level) level.

On Linux and Mac you can only store at the process level.

Calling Set-VSTeamAccount will clear any default project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Set-VSTeamAccount
```

You will be prompted for the account name and personal access token.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Set-VSTeamAccount -Account mydemos -PersonalAccessToken 7a8ilh6db4aforlrnrthisisnotreal4uhlh5vgbmgap3mziwnga
```

Allows you to provide all the information on the command line.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Set-VSTeamAccount -Account http://localtfs:8080/tfs/DefaultCollection -UseWindowsAuthentication
```

On Windows, allows you use to use Windows authentication against a local TFS server.

### -------------------------- EXAMPLE 4 --------------------------

```PowerShell
PS C:\> Set-VSTeamAccount -Profile demonstrations
```

Will add the account from the profile provided.

### -------------------------- EXAMPLE 5 --------------------------

```PowerShell
PS C:\> Set-VSTeamAccount -Profile demonstrations -Drive demo | Invoke-Expression
PS C:\> Set-Location demo:
PS demo:\> Get-ChildItem
```

Will add the account from the profile provided and mount a drive named demo that you can navigate like a file system. If you do not pipe to Invoke-Expression you can simply copy and paste the output and execute it.

### -------------------------- EXAMPLE 6 --------------------------

```PowerShell
PS C:\> Set-VSTeamAccount -Profile demonstrations -Level Machine
```

Will add the account from the profile provided and store the information at the Machine level. Now any new PowerShell sessions will auto load this account.

Note: You must run PowerShell as an Administrator to store at the Machine level.

### -------------------------- EXAMPLE 7 --------------------------

```PowerShell
PS C:\> Set-VSTeamAccount -Account mydemos -Token $(System.AccessToken) -UseBearerToken
```

Will add the account and use the OAuth Token provided by AzD when you check the *Allow scripts to access OAuth token* checkbox on the phase. Using this method removes the need to create a Personal Access Token. Note -Token is just an alias for -PersonalAccessToken.  The token is scoped to only allow access to the account running the build or release. To access other accounts you will have to use a personal access token.

## PARAMETERS

### -Account

The Azure DevOps (AzD) account name to use.
DO NOT enter the entire URL.

Just the portion after dev.azure.com. For example in the
following url mydemos is the account name.
<https://dev.azure.com/mydemos>
or
The full Team Foundation Server (TFS) url including the collection.
<http://localhost:8080/tfs/DefaultCollection>

```yaml
Type: String
Parameter Sets: Secure, Plain, Windows
Required: True
Position: 1
```

### -SecurePersonalAccessToken

A secured string to capture your personal access token.

This will allow you to provide your personal access token without displaying it in plain text.

To use pat simply omit it from the Set-VSTeamAccount command.

```yaml
Type: SecureString
Aliases: PAT
Parameter Sets: Secure
Required: True
```

### -Level

On Windows allows you to store your account information at the Process, User or Machine levels.
When saved at the User or Machine level your account information will be in any future PowerShell processes.

To store at the Machine level you must be running PowerShell as an Administrator.

```yaml
Type: String
Parameter Sets: Secure, Plain, Windows
```

### -PersonalAccessToken

The personal access token from AzD/TFS to use to access this account.

```yaml
Type: String
Parameter Sets: Plain
Aliases: Token
Required: True
Position: 2
```

### -UseWindowsAuthentication

Allows the use of the current user's Windows credentials to authenticate against a local Team Foundation Server or Azure DevOps Server. This cannot be used to connect to Azure DevOps Services.

```yaml
Type: SwitchParameter
Parameter Sets: Windows
```

### -UseBearerToken

Switches the authorization from Basic to Bearer.  You still use the PAT for PersonalAccessToken parameters to store the token.

```yaml
Type: SwitchParameter
Parameter Sets: Secure, Plain
```

### -Profile

The profile name stored using Add-VSTeamProfile function. You can tab complete through existing profile names.

```yaml
Type: String
Parameter Sets: Profile
Required: True
```

### -Version

Specifies the version to use. The acceptable values for this parameter are:

- TFS2017
- TFS2018
- AzD2019
- VSTS
- AzD

If you are on AzD it will default to Azd otherwise it will default to TFS2017

```yaml
Type: String
Parameter Sets: Secure, Plain, Windows
Required: True
Position: 3
Default value: TFS2017 for TFS and AzD for AzD
```

### -Drive

The name of the drive you want to mount to this account. The command you need to run will be presented. Simply copy and paste the command to mount the drive. To use the drive run Set-Location [driveName]:

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

[Add-VSTeamProfile](Add-VSTeamProfile.md)

[Clear-VSTeamDefaultProject](Clear-VSTeamDefaultProject.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

