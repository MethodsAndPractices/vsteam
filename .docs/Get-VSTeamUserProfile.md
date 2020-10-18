<!-- #include "./common/header.md" -->

# Get-VSTeamUserProfile

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamUserProfile.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamUserProfile.md" -->

## EXAMPLES

### Example 1: Get user profile by id

```powershell
$myProfile = Get-VSTeamUserProfile -Id f6e38832-6804-464f-9cf9-4aaa97327cfc
```

### Example 2: Get current users profile

```powershell
$myProfile = Get-VSTeamUserProfile -MyProfile
```

## PARAMETERS

### -Id

Gets the user profile with the given id.

```yaml
   Type: string
   Parameter sets: Id
   Required: true
```

### -MyProfile

Gets all organizations where the user is the owner.

```yaml
   Type: switch
   Parameter sets: Me
   Required: true
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VSTeamBillingToken](Get-VSTeamBillingToken.md)

[Get-VSTeamUserProfile](Get-VSTeamUserProfile.md)

[Set-VSTeamBilling](Set-VSTeamBilling.md)
