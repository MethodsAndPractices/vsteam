


# Update-VSTeamPullRequest

## SYNOPSIS

Update a pull request

## SYNTAX

## DESCRIPTION

Update a pull request

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Set-VSTeamAccount -Account mydemos -Token $(System.AccessToken) -UseBearerToken
PS C:\> $r = Get-VSTeamGitRepository -ProjectName project -Name demorepo
PS C:\> Update-VSTeamPullRequest -RepositoryId $r.RepositoryId -Draft
```

Set the pull request to be a draft

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Set-VSTeamAccount -Account mydemos -Token $(System.AccessToken) -UseBearerToken
PS C:\> $r = Get-VSTeamGitRepository -ProjectName project -Name demorepo
PS C:\> Update-VSTeamPullRequest -RepositoryId $r.RepositoryId -Status abandoned
```

Abandon a pull request

## PARAMETERS

### -RepositoryId

The id of the repository

```yaml
Type: Guid
Required: True
Aliases: Id
Accept pipeline input: true (ByPropertyName)
Parameter Sets: Draft, Publish, Status, EnableAutoComplete, DisableAutoComplete
```

### -PullRequestId

The id of the pull request

```yaml
Type: Int32
Required: True
Parameter Sets: Draft, Publish, Status, EnableAutoComplete, DisableAutoComplete
```

### -Status

The status to set the pull request to. Valid values for this are:

- abandoned
- active
- completed
- notSet

```yaml
Type: String
Parameter Sets: Status
```

### -EnableAutoComplete

Set the pull requests auto complete status

```yaml
Type: Switch
Parameter Sets: EnableAutoComplete
```

### -AutoCompleteIdentity

The identity that enabled autocomplete. This is mandatory if -AutoComplete is set to $true

```yaml
Type: VSTeamUser
Parameter Sets: EnableAutoComplete
```

### -DisableAutoComplete

Unset the pull requests auto complete status

```yaml
Type: Switch
Parameter Sets: DisableAutoComplete
```

### -Draft

Set the pull request as a draft

```yaml
Type: Switch
Parameter Sets: Draft
```

### -Confirm

Prompts you for confirmation before running the function.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
Aliases: cf
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

### -WhatIf

Shows what would happen if the function runs.
The function is not run.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
Aliases: wi
```

## INPUTS

## OUTPUTS

### Team.PullRequest

## NOTES

## RELATED LINKS

