<!-- #include "./common/header.md" -->

# Get-VSTeamAccounts

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamAccounts.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamAccounts.md" -->

## EXAMPLES

### Example 1: Get organizations where the user is owner

```powershell
$myProfile = Get-VSTeamUserProfile -MyProfile
$orgs = Get-VSTeamAccounts -MemberId $myProfile.id
```

### Example 2: Get organizations where the user is member

```powershell
$myProfile = Get-VSTeamUserProfile -MyProfile
$orgs = Get-VSTeamAccounts -OwnerId $myProfile.id
```

## PARAMETERS

### -MemberId

Gets all organizations where the user is a member.

```yaml
   Type: string
   Parameter sets: MemberId
   Required: true
```

### -OwnerId

Gets all organizations where the user is the owner.

```yaml
   Type: string
   Parameter sets: OwnerId
   Required: true
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VSTeamUserProfile](Get-VSTeamUserProfile.md)

[Set-VSTeamPipelineBilling](Set-VSTeamPipelineBilling.md)
