#include "./common/header.md"

# Add-VSTeamProfile

## SYNOPSIS
#include "./synopsis/Add-VSTeamProfile.md"

## SYNTAX

### Secure (Default)
```
Add-VSTeamProfile [-Account] <String> -PAT <SecureString> [[-Name] <String>]
```

### Plain
```
Add-VSTeamProfile [-PersonalAccessToken] <String> [[-Account] <String>] [[-Name] <String>]
```

### TFS
```
Add-VSTeamProfile [[-Account] <String>] [-UseWindowsAuthentication] [[-Name] <String>]
```

## DESCRIPTION

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Add-VSTeamProfile
```

You will be prompted for the account name and personal access token.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Add-VSTeamProfile -Account mydemos -PersonalAccessToken 7a8ilh6db4aforlrnrqmdrxdztkjvcc4uhlh5vgbmgap3mziwnga
```

Allows you to provide all the information on the command line.

### -------------------------- EXAMPLE 3 --------------------------
```
PS C:\> Add-VSTeamProfile -Account http://localtfs:8080/tfs/DefaultCollection -UseWindowsAuthentication
```

On Windows, allows you use to use Windows authentication against a local TFS server.

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

To use pat simply omit it from the Add-VSTeamProfile command.

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

### -Name
Optional name for the profile. If this parameter is not provided the account will also
serve as the name.

```yaml
Type: String
Parameter Sets: All
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)