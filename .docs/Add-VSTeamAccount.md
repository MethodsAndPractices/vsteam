#include "./common/header.md"

# Add-VSTeamAccount

## SYNOPSIS
#include "./synopsis/Add-VSTeamAccount.md"

## SYNTAX

### Secure (Default)
```
Add-VSTeamAccount [-Account] <String> -PAT <SecureString> [-Level <String>] [[-Version] <String>]
```

### Plain
```
Add-VSTeamAccount [-PersonalAccessToken] <String> [[-Account] <String>] [-Level <String>] [[-Version] <String>]
```

### Windows
```
Add-VSTeamAccount [[-Account] <String>] [-UseWindowsAuthentication] [[-Version] <String>]
```

### Profile
```
Add-VSTeamAccount [[-Profile] <String>] [-Level <String>] [[-Version] <String>]
```

## DESCRIPTION
On Windows you have to option to store the information at the process, user
or machine (you must be running PowerShell as administrator to store at the
machine level) level.

On Linux and Mac you can only store at the process level.

Calling Add-VSTeamAccount will clear any default project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Add-VSTeamAccount
```

You will be prompted for the account name and personal access token.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Add-VSTeamAccount -Account mydemos -PersonalAccessToken 7a8ilh6db4aforlrnrqmdrxdztkjvcc4uhlh5vgbmgap3mziwnga
```

Allows you to provide all the information on the command line.

### -------------------------- EXAMPLE 3 --------------------------
```
PS C:\> Add-VSTeamAccount -Account http://localtfs:8080/tfs/DefaultCollection -UseWindowsAuthentication
```

On Windows, allows you use to use Windows authentication against a local TFS server.

### -------------------------- EXAMPLE 4 --------------------------
```
PS C:\> Add-VSTeamAccount -Profile demonstrations
```

Will add the account from the profile provide.

## PARAMETERS

### -Account
The Visual Studio Team Services (VSTS) account name to use.
DO NOT enter the entire URL. 

Just the portion before visualstudio.com. For example in the
following url mydemos is the account name.
https://mydemos.visualstudio.com
or
The full Team Foundation Server (TFS) url including the collection.
http://localhost:8080/tfs/DefaultCollection

```yaml
Type: String
Parameter Sets: Secure (Default)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Plain, Windows
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PAT
A secured string to capture your personal access token. 

This will allow you to provide your personal access token
without displaying it in plain text.

To use pat simply omit it from the Add-VSTeamAccount command.

```yaml
Type: SecureString
Parameter Sets: Secure (Default)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Level
On Windows allows you to store your account information at the Process, User or Machine levels. 
When saved at the User or Machine level your account information will be in any future PowerShell processes.

```yaml
Type: String
Parameter Sets: Secure, Plain (Default)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PersonalAccessToken
The personal access token from VSTS/TFS to use to access this account.

```yaml
Type: String
Parameter Sets: Plain
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseWindowsAuthentication
Allows the use of the current user's Windows credentials to authenticate against a local TFS.

```yaml
Type: SwitchParameter
Parameter Sets: Windows
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Profile
The profile name stored using Add-VSTeamProfile function. You can tab complete through existing profile names.

```yaml
Type: String
Parameter Sets: Profile
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
### -Version
Specifies the version to use.

Valid values: 'TFS2017', 'TFS2018', 'VSTS'

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: TFS2017
Accept pipeline input: False
Accept wildcard characters: False
```
## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Add-VSTeamProfile](Add-VSTeamProfile.md)
[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)